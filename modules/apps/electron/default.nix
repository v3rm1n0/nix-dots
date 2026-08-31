_: {
  flake.modules.nixos.default =
    { lib, hostUsernames, ... }:
    {
      config = lib.mkMerge (
        map (name: {
          hjem.users.${name}.files.".config/electron-flags.conf".source = ./electron-flags.conf;
        }) hostUsernames
      );
    };
}
