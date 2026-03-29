{ self, inputs, ... }:
{
  flake.nixosModules.applicationsBrowsing =
    { pkgs, lib, ... }:
    {
      imports = [
        self.nixosModules.applicationsBrowsingChromium
        self.nixosModules.applicationsBrowsingFirefox
        self.nixosModules.applicationsBrowsingTor
      ];
    };
}
