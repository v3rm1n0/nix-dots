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
      inherit (config.userOptions) username;
      myAliases = self.lib.commonAliases;
      aliasLines = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (n: v: "alias ${n}=${lib.escapeShellArg v}") myAliases
      );
    in
    {
      imports = [ self.nixosModules.modulesShellZshP10k ];

      options.shell.zsh.enable = lib.mkEnableOption "Enable zsh Module";

      config = lib.mkIf config.shell.zsh.enable {
        environment.shells = [ pkgs.zsh ];
        environment.systemPackages = [ pkgs.fzf ];

        # NixOS base: registers zsh as a login shell, writes /etc/zshrc and sets
        # up system completion. Interactive config lives in hjem-rum below.
        programs.zsh = {
          enable = true;
          enableCompletion = true;
        };

        hjem.users.${username}.rum.programs.zsh = {
          enable = true;
          initConfig = ''
            source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
            source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
            source ~/.config/zsh/.p10k.zsh
            POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

            HISTSIZE=10000
            SAVEHIST=10000

            ${aliasLines}

            ZSH_AUTOSUGGEST_STRATEGY=(completion history)
            source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

            eval "$(tirith init --shell zsh)"
            eval "$(zoxide init --cmd cd zsh)"
            source <(fzf --zsh)

            source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
          '';
        };
      };
    };
}
