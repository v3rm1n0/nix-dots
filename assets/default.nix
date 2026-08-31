_: {
  flake.modules.nixos.default =
    { lib, hostUsernames, ... }:
    {
      config = lib.mkMerge (
        map (username: {
          hjem.users.${username}.files = {
            ".config/backgrounds".source = ./wallpapers;
            ".config/nixlogo.png".source = ./logo/nix-snowflake.png;
          };
        }) hostUsernames
      );
    };
}
