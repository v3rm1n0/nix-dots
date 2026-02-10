{
  config,
  lib,
  pkgs,
  ...
}:
let
  myAliases = import ./commonAliases.nix;
  username = config.userOptions.username;
in
{
  options.shell.zsh = {
    enable = lib.mkEnableOption "Enable zsh Module";
  };

  config = lib.mkIf config.shell.zsh.enable {
    environment.shells = with pkgs; [ zsh ];
    environment.systemPackages = with pkgs; [ zsh-autocomplete ];

    home-manager.users.${username} = {
      programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        autosuggestion.strategy = [ "completion" ];
        dotDir = "/home/${username}/.config/zsh";
        enableCompletion = false;
        syntaxHighlighting.enable = true;
        shellAliases = myAliases;
        plugins = [
          {
            name = "tirith";
            file = "tirith.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "sheeki03";
              repo = "ohmyzsh-tirith";
              rev = "b7328455c46f8a5d3890faab4810c6ab0be8bc64";
              sha256 = "sha256-aN2ILfpNvWq/meFBxX9Bvi5fJAtbwf57CNrozZGslsk=";
            };
          }
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "chisui";
              repo = "zsh-nix-shell";
              rev = "v0.8.0";
              sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
            };
          }
        ];
        zplug = {
          enable = true;
          plugins = [
            {
              name = "romkatv/powerlevel10k";
              tags = [
                "as:theme"
                "depth:1"
              ];
            }
          ];
        };
        initContent = ''
          source ~/.config/zsh/.p10k.zsh
          POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
          eval "$(tirith init --shell zsh)"
          eval "$(zoxide init --cmd cd zsh)"
        '';
      };
    };
  };
}
