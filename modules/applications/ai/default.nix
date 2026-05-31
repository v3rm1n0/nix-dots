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
      options.programs.ai.enable = lib.mkEnableOption "Enables ai module";

      config = lib.mkIf config.programs.ai.enable {
        services.ollama = {
          enable = false;
          package = pkgs.ollama-cuda;
        };

        hjem.users.${username} = {
          packages =
            (with pkgs; [
              jq
              claude-code
            ])
            ++ [
              inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.ccusage
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
            };
          };
        };
      };
    };
}
