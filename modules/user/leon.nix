_: {
  flake.modules.nixos."user/leon" =
    { pkgs, ... }:
    {
      users.users.leon = {
        shell = pkgs.fish;
        isNormalUser = true;
        hashedPassword = "$y$j9T$JAtdg7dg9j3SFRFpasQpK1$jb7gcYJsFiPxZnDwlOiD.50.BjqKyoIyjbMSkDOO/x9";
        extraGroups = [ "wheel" ];
      };

      hjem.users.leon.enable = true;
    };
}
