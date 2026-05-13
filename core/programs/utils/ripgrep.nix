_: {
  flake.nixosModules.coreProgramsUtilsRipgrep =
    {
      config,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
    in
    {
      environment.sessionVariables.RIPGREP_CONFIG_PATH = "$HOME/.ripgreprc";
      environment.systemPackages = [ pkgs.ripgrep ];
      hjem.users.${username}.files.".ripgreprc".text = ''
        --glob=!.git/*
        --glob=!flake.lock
      '';
    };
}
