{ self, ... }:
{
  flake.nixosModules.applicationsBrowsing =
    { ... }:
    {
      imports = [
        self.nixosModules.applicationsBrowsingChromium
        self.nixosModules.applicationsBrowsingFirefox
        self.nixosModules.applicationsBrowsingTor
      ];
    };
}
