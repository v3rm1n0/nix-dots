{ inputs, ... }:
{
  flake.modules.nixos.default =
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

      programs.zsh.enable = false;
      users.mutableUsers = true;
      users.defaultUserShell = pkgs.fish;
      users.users.${username} = {
        shell = config.users.defaultUserShell;
        isNormalUser = true;
        hashedPassword = "$6$TSeuDdaiycwV2p9R$SfYPYi5lKha0PLWOqoCXTJW8/SthhJ3R99Hfvo8g5AT5hR3BZIUTmXNmxU03DyJNrSu/yh6SDwkbEXIOOlETO.";
        extraGroups = [
          "docker"
          "wheel"
          "openrazer"
        ];
      };

      hjem = {
        extraModules = [
          inputs.hjem-rum.hjemModules.default
        ];
        users.${username}.enable = true;
        clobberByDefault = true;
      };
    };
}
