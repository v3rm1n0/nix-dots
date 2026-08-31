{ self, inputs, ... }:
let
  hostUserProfiles = {
    Desktop = {
      v3rm1n = {
        isAdmin = true;
        browser = "helium";
        wallpaper = "rocket.png";
        wm = "hyprland";
        apps = [
          "ai"
          "browsing-helium"
          "comms"
          "content"
          "dev"
          "emulators"
          "gaming"
          "media"
          "productivity"
          "terminal"
          "uni"
        ];
      };

      leon = {
        isAdmin = false;
        browser = "firefox";
        wallpaper = "kanagawa.png";
        wm = "cinnamon";
        apps = [
          "browsing-firefox"
          "media"
          "productivity"
          "terminal"
        ];
      };
    };

    Laptop = {
      v3rm1n = {
        isAdmin = true;
        browser = "librewolf";
        wallpaper = "rocket.png";
        wm = "hyprland";
        apps = [
          "ai"
          "browsing-firefox"
          "comms"
          "dev"
          "emulators"
          "gaming"
          "media"
          "productivity"
          "terminal"
          "uni"
        ];
      };
    };

    Template = {
      v3rm1n = {
        isAdmin = true;
        browser = "librewolf";
        wallpaper = "rocket.png";
        wm = "hyprland";
        apps = [ ];
      };
    };
  };

  mkHost =
    name:
    let
      userProfiles = hostUserProfiles.${name};
      usernames = builtins.attrNames userProfiles;
    in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        hostUsernames = usernames;
        inherit userProfiles;
      };
      modules = [
        self.modules.nixos.default
        self.modules.nixos."host/${name}"
      ]
      ++ map (user: self.modules.nixos."user/${user}") usernames;
    };
in
{
  flake.nixosConfigurations = {
    Desktop = mkHost "Desktop";
    Laptop = mkHost "Laptop";
    Template = mkHost "Template";
  };
}
