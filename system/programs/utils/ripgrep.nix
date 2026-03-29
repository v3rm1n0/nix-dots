{ self, inputs, ... }:
{
  flake.nixosModules.coreProgramsUtilsRipgrep =
    {
      config,
      pkgs,
      ...
    }:
    let
      username = config.userOptions.username;
    in
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      environment.sessionVariables = {
        RIPGREP_CONFIG_PATH = "$HOME/.ripgreprc";
      };
      environment.systemPackages = with pkgs; [
        ripgrep
      ];

      home-manager.users.${username} = {
        home.file.".ripgreprc".text = ''
          --glob=!.git/*
          --glob=!flake.lock
        '';
      };
    };
}
