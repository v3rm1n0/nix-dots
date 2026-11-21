_: {
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

      # omniroute 3.8.53 -> 3.8.54 from NixOS/nixpkgs#590496 (fixes the hydra
      # build by shrinking the output). Drop once it lands in nixpkgs.
      # npmDeps is rebuilt by hand: buildNpmPackage derives it from the
      # original args, so overriding only npmDepsHash would have no effect.
      omniroute = pkgs.omniroute.overrideAttrs (
        finalAttrs: _: {
          version = "3.8.54";
          src = pkgs.fetchFromGitHub {
            owner = "cheaper-inference";
            repo = "OmniRoute";
            tag = "v${finalAttrs.version}";
            hash = "sha256-KDxELGSEZx33UPTykC2Fh5t3BAvrcCoSWwEiA1qEuvc=";
          };
          npmDeps = pkgs.fetchNpmDeps {
            inherit (finalAttrs) src patches postPatch;
            name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
            hash = "sha256-j4FY5YaIN+PqI1BurtfI5DRdQif3tKIsTpthOo+7A/Q=";
            fetcherVersion = 2;
          };
        }
      );
    in
    {
      options.mods.apps.ai = {
        enable = lib.mkEnableOption "Enables ai module";
      };

      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          {
            services.ollama = {
              enable = false;
              package = pkgs.ollama-cuda;
            };

            services.omniroute = {
              enable = true;
              package = omniroute;
              settings = {
                HOSTNAME = "127.0.0.1";
              };
            };

            hjem.users.${username} = {
              packages = [
                config.services.omniroute.package
                pkgs.jq
                pkgs.sox
                pkgs.claude-code
                pkgs.opencode
              ];

              files.".claude/settings.json" = {
                generator = lib.generators.toJSON { };
                value = {
                  "$schema" = "https://json.schemastore.org/claude-code-settings.json";
                  extraKnownMarketplaces = {
                    claude-code-delegate = {
                      source = {
                        source = "github";
                        repo = "NightZpy/claude-code-delegate";
                      };
                    };
                    superpowers-marketplace = {
                      source = {
                        source = "github";
                        repo = "obra/superpowers-marketplace";
                      };
                    };
                  };
                  enabledPlugins = {
                    "cc-delegate@claude-code-delegate" = true;
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
        ]
      );
    };
}
