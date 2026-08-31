_: {
  flake.modules.nixos."user/v3rm1n" =
    { pkgs, ... }:
    {
      users.users.v3rm1n = {
        shell = pkgs.fish;
        isNormalUser = true;
        hashedPassword = "$6$TSeuDdaiycwV2p9R$SfYPYi5lKha0PLWOqoCXTJW8/SthhJ3R99Hfvo8g5AT5hR3BZIUTmXNmxU03DyJNrSu/yh6SDwkbEXIOOlETO.";
        extraGroups = [
          "docker"
          "wheel"
          "openrazer"
        ];
      };

      hjem.users.v3rm1n.enable = true;
    };
}
