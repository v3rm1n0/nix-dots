{ self, ... }:
{
  flake.nixosModules.modulesShellZsh =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      myAliases = self.lib.commonAliases;
    in
    {
      imports = [ self.nixosModules.modulesShellZshP10k ];

      options.shell.zsh.enable = lib.mkEnableOption "Enable zsh Module";

      config = lib.mkIf config.shell.zsh.enable {
        environment.shells = [ pkgs.zsh ];
        environment.systemPackages = [ pkgs.fzf ];

        programs.zsh = {
          enable = true;
          autosuggestions = {
            enable = true;
            strategy = [
              "completion"
              "history"
            ];
          };
          syntaxHighlighting.enable = true;
          enableCompletion = true;
          shellAliases = myAliases;
          histSize = 10000;

          interactiveShellInit = ''
            source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
            source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
            source ~/.config/zsh/.p10k.zsh
            POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
            eval "$(tirith init --shell zsh)"
            eval "$(zoxide init --cmd cd zsh)"
            source <(fzf --zsh)
          '';
        };
      };
    };
}
