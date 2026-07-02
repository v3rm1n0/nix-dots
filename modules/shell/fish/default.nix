{ self, ... }:
{
  flake.nixosModules.modulesShellFish =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
      myAliases = self.lib.commonAliases;
    in
    {
      options.shell.fish.enable = lib.mkEnableOption "Enable fish Module";

      config = lib.mkIf config.shell.fish.enable {
        programs.fish.enable = true;

        # Vendored fish plugins are installed system-wide so fish discovers them
        # via /run/current-system/sw/share/fish/vendor_*. tide provides the prompt
        # (installing it as a package is what fixes the previously-broken tide).
        environment.systemPackages = with pkgs.fishPlugins; [
          tide
          puffer
          done
          bass
          fzf-fish
        ];

        hjem.users.${username}.rum.programs.fish = {
          enable = true;
          aliases = myAliases;
          config = ''
            set -g fish_greeting
            ${lib.getExe pkgs.any-nix-shell} fish --info-right | source
            ${lib.getExe pkgs.direnv} hook fish | source
            ${lib.getExe pkgs.tirith} init --shell fish | source
            ${lib.getExe pkgs.zoxide} init fish --cmd cd | source
          '';
        };
      };
    };
}
