{ inputs, self, ... }:
{
  perSystem =
    {
      lib,
      pkgs,
      self',
      ...
    }:
    let
      myAliases = self.lib.commonAliases;
    in
    {
      packages.fish = inputs.wrapper-modules.wrappers.fish.wrap {
        inherit pkgs;
        package = pkgs.fish;
        configFile.content = ''
          set -g fish_greeting
          set -gx STARSHIP_CONFIG ${self'.packages.starship}/starship.toml
          ${lib.getExe pkgs.any-nix-shell} fish --info-right | source
          ${lib.getExe pkgs.direnv} hook fish | source
          ${lib.getExe self'.packages.starship} init fish | source
          ${lib.getExe pkgs.tirith} init --shell fish | source
          ${lib.getExe pkgs.zoxide} init fish --cmd cd | source
        '';
        runtimePkgs = [ self'.packages.starship ];
        flags."--no-config" = false;
        plugins = with pkgs.fishPlugins; [
          bass
          fzf-fish
          #tide #Broken somehow?
        ];
        shellAliases = myAliases;
      };
    };
}
