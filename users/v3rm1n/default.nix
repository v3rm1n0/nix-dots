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
        hashedPassword = "$6$TSeuDdaiycwV2p9R$SfYPYi5lKha0PLWOqoCXTJW8/SthhJ3R99Hfvo8g5AT5hR3BZIUTmXNmxU03DyJNrSu/yh6SDwkbEXIOOlETO.";
        initialHashedPassword = "$6$MtOmPT5eXBAUeObZ$bgsp7GS17AGGjJQlmmoIx8NHfhEQVgU91hOqtHe9p6nOedPWMxjnwtDHMNJjReh0CYJA755srEaqQ9ygDYBRN1";
        extraGroups = [
          "docker"
          "wheel"
          "openrazer"
        ];
      };
      users.defaultUserShell = pkgs.zsh;
    };
}
