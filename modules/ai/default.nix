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
    in
    {
      imports = [ "${inputs.nixpkgs-omniroute}/nixos/modules/services/web-apps/omniroute.nix" ];

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
              package = pkgs.callPackage "${inputs.nixpkgs-omniroute}/pkgs/by-name/om/omniroute/package.nix" { };
            };

            hjem.users.${username} = {
              packages = [
                (pkgs.callPackage "${inputs.nixpkgs-omniroute}/pkgs/by-name/om/omniroute/package.nix" { })
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
        ]
      );
    };
}
