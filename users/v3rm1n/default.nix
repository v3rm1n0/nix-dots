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
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      programs.zsh.enable = true;
      users.users.${username} = {
        shell = pkgs.zsh;
        isNormalUser = true;
        initialPassword = "temp123";
        extraGroups = [
          "docker"
          "wheel"
          "openrazer"
        ];
      };
      users.defaultUserShell = pkgs.zsh;
    };
}
