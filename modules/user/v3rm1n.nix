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

      # No password hash is stored in the tree. `users.mutableUsers` is on, so
      # the password is set once after install (`passwd <user>` as root from the
      # installer or a root shell). A committed SHA-512 crypt hash is offline
      # crackable, and this repository is public.
      programs.zsh.enable = false;
      users = {
        mutableUsers = true;
        defaultUserShell = pkgs.fish;
        users.${username} = {
          shell = config.users.defaultUserShell;
          isNormalUser = true;
          # "docker" is granted by the emulators module that enables docker.
          extraGroups = [
            "wheel"
            "openrazer"
          ];
        };
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
