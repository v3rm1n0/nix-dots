{ self, ... }:
{
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      hostUsernames,
      ...
    }:
    let
      myAliases = self.lib.commonAliases;
    in
    {
      options.mods.shell.fish.enable = lib.mkEnableOption "Enable fish Module";

      config = lib.mkIf config.mods.shell.fish.enable (
        lib.mkMerge (
          [
            {
              programs.fish.enable = true;

              environment.systemPackages =
                with pkgs.fishPlugins;
                [
                  puffer
                  done
                  bass
                  fzf-fish
                ]
                ++ [ pkgs.jj-starship ];
            }
          ]
          ++ map (username: {
            hjem.users.${username}.rum.programs.fish = {
              enable = true;
              aliases = myAliases;
              config = ''
                set -g fish_greeting
                set -gx STARSHIP_CONFIG ${self.packages.${pkgs.stdenv.hostPlatform.system}.starship}/starship.toml
                ${lib.getExe pkgs.any-nix-shell} fish --info-right | source
                ${lib.getExe pkgs.direnv} hook fish | source
                ${lib.getExe pkgs.tirith} init --shell fish | source
                ${lib.getExe pkgs.zoxide} init fish --cmd cd | source
                ${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.starship} init fish | source
              '';
            };
          }) hostUsernames
        )
      );
    };
}
