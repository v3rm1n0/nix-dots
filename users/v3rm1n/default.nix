{
  config,
  pkgs,
  ...
}:
let
  username = config.userOptions.username;
in
{
  programs.zsh.enable = true;
  users.users.${username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    initialPassword = "temp123";
    extraGroups = [
      "wheel"
      "openrazer"
    ];
  };
  users.defaultUserShell = pkgs.zsh;
}
