{
  config,
  lib,
  pkgs,
  ...
}:
let
  username = config.userOptions.username;
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
      home.sessionVariables = {
        ANTHROPIC_BASE_URL = "http://localhost:11434";
        ANTHROPIC_AUTH_TOKEN = "ollama";
      };

      programs.claude-code.enable = true;
    };
  };
}
