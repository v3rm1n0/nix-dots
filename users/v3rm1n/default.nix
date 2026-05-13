{ inputs, ... }:
{
  flake.nixosModules.usersV3rm1n =
    {
      config,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
    in
    {
      imports = [ inputs.hjem.nixosModules.hjem ];

      programs.zsh.enable = true;
      users.users.${username} = {
        shell = pkgs.zsh;
        isNormalUser = true;
        hashedPassword = "$6$TSeuDdaiycwV2p9R$SfYPYi5lKha0PLWOqoCXTJW8/SthhJ3R99Hfvo8g5AT5hR3BZIUTmXNmxU03DyJNrSu/yh6SDwkbEXIOOlETO.";
        extraGroups = [
          "docker"
          "wheel"
          "openrazer"
        ];
      };

      hjem.users.${username}.enable = true;
    };
}
