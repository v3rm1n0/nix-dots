{ inputs, ... }:
{
  flake.nixosModules.applicationsAi =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
    in
    {
      options.programs.ai = {
        enable = lib.mkEnableOption "Enables ai module";
      };

      config = lib.mkIf config.programs.ai.enable {
        services.ollama = {
          enable = true;
          package = pkgs.ollama-cuda;
        };

        home-manager.users.${username} = {
          home.packages = (with pkgs; [ jq ]) ++ [
            inputs.nixpkgs-ccusage.legacyPackages.${pkgs.stdenv.hostPlatform.system}.ccusage
          ];
          programs.claude-code = {
            enable = true;
            settings = {
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
            };
          };
        };
      };
    };
}
