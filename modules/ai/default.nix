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
