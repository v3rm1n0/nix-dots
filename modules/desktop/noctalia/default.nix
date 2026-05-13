{ inputs, ... }:
{
  flake.nixosModules.modulesDesktopNoctalia =
    {
      config,
      pkgs,
      self,
      ...
    }:
    let
      inherit (config.userOptions) username hostName wallpaper;
    in
    {
      imports = [ inputs.noctalia.nixosModules.default ];

      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.${
          if hostName == "Laptop" then "noctalia-shell-laptop" else "noctalia-shell"
        }
      ];

      hjem.users.${username} = {
        files.".cache/noctalia/wallpapers.json" = {
          text = builtins.toJSON {
            defaultWallpaper = "/home/${username}/.config/backgrounds/${wallpaper}";
          };
        };
      };
    };
}
