_: {
  flake.modules.nixos.default =
    {
      lib,
      pkgs,
      hostUsernames,
      ...
    }:
    {
      config = lib.mkMerge (
        [
          {
            environment.sessionVariables.RIPGREP_CONFIG_PATH = "$HOME/.ripgreprc";
            environment.systemPackages = [ pkgs.ripgrep ];
          }
        ]
        ++ map (username: {
          hjem.users.${username}.files.".ripgreprc".text = ''
            --glob=!.git/*
            --glob=!flake.lock
          '';
        }) hostUsernames
      );
    };
}
