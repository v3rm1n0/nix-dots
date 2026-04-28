_: {
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
          home.packages = with pkgs; [
            jq
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
                padding = 0;
                type = "command";
              };
            };
          };
          home.file.".claude/statusline.sh" = {
            source = ./statusline.sh;
            executable = true;
          };
        };
      };
    };
}
