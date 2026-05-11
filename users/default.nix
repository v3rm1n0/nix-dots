{ self, ... }:
{
  flake.nixosModules.users =
    {
      pkgs,
      ...
    }:
    {
      imports = [
        self.nixosModules.usersV3rm1n
      ];
      users.mutableUsers = true;
      users.defaultUserShell = pkgs.zsh;
    };
}
