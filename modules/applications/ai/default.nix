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
          programs.claude-code.enable = true;
        };
      };
    };
}
