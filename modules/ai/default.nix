{ inputs, ... }: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
      cfg = config.mods.apps.ai;
      llama = cfg.llama;

      llamaCpp = pkgs.llama-cpp.override { cudaSupport = true; };
      serverFor = m: lib.getExe' (if m.package == null then llamaCpp else m.package) "llama-server";

      mkModelCmd =
        m:
        lib.concatStringsSep " " (
          [
            (serverFor m)
            "--port \${PORT}"
            "-m ${llama.modelDir}/${m.file}"
            "-ngl 99"
            "-c ${toString llama.ctxSize}"
            "-t ${toString llama.threads}"
            "-fa on"
            "--jinja"
          ]
          ++ lib.optional (m.nCpuMoe > 0) "--n-cpu-moe ${toString m.nCpuMoe}"
          ++ lib.optional (!m.kvOffload) "--no-kv-offload"
          ++ m.extraArgs
          ++ lib.optionals llama.kvCacheQ8 [
            "-ctk q8_0"
            "-ctv q8_0"
          ]
        );

      assoc = f: lib.concatStringsSep " " (lib.mapAttrsToList (n: m: ''["${n}"]="${f m}"'') llama.models);

      downloadScript = pkgs.writeShellApplication {
        name = "llama-models-download";
        runtimeInputs = [
          pkgs.python3Packages.huggingface-hub
          pkgs.coreutils
        ];
        text = ''
          # usage: llama-models-download [model...]   (default: all configured models)
          dir=${llama.modelDir}
          declare -A repo=(${assoc (m: m.repo)})
          declare -A file=(${assoc (m: m.file)})
          declare -A size=(${assoc (m: toString m.size)})

          if [ "$#" -eq 0 ]; then set -- "''${!repo[@]}"; fi

          for name in "$@"; do
            if [ -z "''${repo[$name]:-}" ]; then
              echo "unknown model: $name (known: ''${!repo[*]})" >&2
              exit 1
            fi
            hf download "''${repo[$name]}" "''${file[$name]}" --local-dir "$dir"
            # the service runs as a dynamic user and needs read access
            chmod a+r "$dir/''${file[$name]}"
            actual=$(stat -c %s "$dir/''${file[$name]}")
            if [ "$actual" != "''${size[$name]}" ]; then
              echo "size mismatch for $name: expected ''${size[$name]}, got $actual" >&2
              exit 1
            fi
            echo "ok: $name ($actual bytes)"
          done
        '';
      };
    in
    {
      options.mods.apps.ai = {
        enable = lib.mkEnableOption "Enables ai module";

        llama = {
          enable = lib.mkEnableOption "local CUDA llama.cpp served through llama-swap";

          port = lib.mkOption {
            type = lib.types.port;
            default = 8080;
            description = "Port of the OpenAI-compatible endpoint (bound to 127.0.0.1).";
          };

          modelDir = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/llama-cpp/models";
            description = "Directory holding the GGUF files (outside the Nix store).";
          };

          ctxSize = lib.mkOption {
            type = lib.types.int;
            default = 32768;
            description = "Context size passed to llama-server (-c).";
          };

          threads = lib.mkOption {
            type = lib.types.int;
            default = 6;
            description = "CPU threads (-t); the i5-12400F has 6 physical cores.";
          };

          ttl = lib.mkOption {
            type = lib.types.int;
            default = 300;
            description = "Seconds of idleness before llama-swap unloads a model and frees its VRAM; 0 keeps it loaded.";
          };

          kvCacheQ8 = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Quantize the KV cache to q8_0 (-ctk/-ctv), halving its VRAM use.";
          };

          models = lib.mkOption {
            description = "Models served by llama-swap, keyed by the model name clients request.";
            type = lib.types.attrsOf (
              lib.types.submodule {
                options = {
                  repo = lib.mkOption {
                    type = lib.types.str;
                    description = "Hugging Face repository.";
                  };
                  file = lib.mkOption {
                    type = lib.types.str;
                    description = "GGUF filename inside the repository and the model directory.";
                  };
                  size = lib.mkOption {
                    type = lib.types.int;
                    description = "Exact file size in bytes, used by the download helper to verify.";
                  };
                  nCpuMoe = lib.mkOption {
                    type = lib.types.int;
                    default = 0;
                    description = "MoE layers whose experts stay on the CPU (--n-cpu-moe); 0 disables.";
                  };
                  kvOffload = lib.mkOption {
                    type = lib.types.bool;
                    default = true;
                    description = ''
                      Keep the KV cache in VRAM. Set false (--no-kv-offload) for dense models whose
                      weights plus KV cache exceed the GPU; the cache then lives in system RAM.
                    '';
                  };
                  extraArgs = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    default = [ ];
                    example = [ "--temp 1.0" ];
                    description = "Extra llama-server arguments for this model (e.g. sampling settings).";
                  };
                  env = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    default = [ ];
                    example = [ "LLAMA_ARG_CHAT_TEMPLATE_KWARGS={\"reasoning_effort\":\"none\"}" ];
                    description = "Environment variables (NAME=value) for this model's llama-server process.";
                  };
                  filters = lib.mkOption {
                    type = lib.types.attrs;
                    default = { };
                    example = {
                      stripParams = "reasoning_effort";
                    };
                    description = "llama-swap request filters (stripParams, setParams) applied to every request for this model.";
                  };
                  package = lib.mkOption {
                    type = lib.types.nullOr lib.types.package;
                    default = null;
                    description = "llama.cpp package serving this model; null uses the shared CUDA build.";
                  };
                };
              }
            );
          };
        };
      };

      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          {
            services.ollama = {
              enable = false;
              package = pkgs.ollama-cuda;
            };

            hjem.users.${username} = {
              packages = [
                pkgs.jq
                pkgs.sox
                pkgs.claude-code
                # (import inputs.claude-code {
                #   inherit (pkgs.stdenv.hostPlatform) system;
                #   config.allowUnfree = true;
                # }).claude-code
              ];

              files.".claude/settings.json" = {
                generator = lib.generators.toJSON { };
                value = {
                  "$schema" = "https://json.schemastore.org/claude-code-settings.json";
                  extraKnownMarketplaces = {
                    superpowers-marketplace = {
                      source = {
                        source = "github";
                        repo = "obra/superpowers-marketplace";
                      };
                    };
                  };
                  enabledPlugins = {
                    "superpowers@claude-plugins-official" = true;
                  };
                  statusLine = {
                    command = "~/.claude/statusline.sh";
                    type = "command";
                  };
                  voice = {
                    enabled = true;
                    mode = "tap";
                  };
                };
              };
            };
          }

          (lib.mkIf llama.enable {
            mods.apps.ai.llama.models = lib.mapAttrs (_: lib.mapAttrs (_: lib.mkDefault)) {
              coder-next = {
                repo = "unsloth/Qwen3-Coder-Next-GGUF";
                file = "Qwen3-Coder-Next-Q4_K_M.gguf";
                size = 48528320544;
                # 40 leaves too little VRAM for the compute buffers on a 12 GB GPU; 44 loads (~8.3 GB).
                nCpuMoe = 44;
              };
            };

            nix.settings = {
              extra-substituters = [ "https://cache.nixos-cuda.org" ];
              extra-trusted-public-keys = [
                "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
              ];
            };

            services.llama-swap = {
              enable = true;
              listenAddress = "127.0.0.1";
              inherit (llama) port;
              settings = {
                healthCheckTimeout = 600;
                models = lib.mapAttrs (
                  _: m:
                  {
                    cmd = mkModelCmd m;
                    inherit (llama) ttl;
                  }
                  // lib.optionalAttrs (m.env != [ ]) { inherit (m) env; }
                  // lib.optionalAttrs (m.filters != { }) { inherit (m) filters; }
                ) llama.models;
              };
            };

            systemd.tmpfiles.rules = [ "d ${llama.modelDir} 0755 ${username} users -" ];

            environment.systemPackages = [ downloadScript ];
          })
        ]
      );
    };
}
