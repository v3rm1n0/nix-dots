{ self, inputs, ... }:
{
  flake.nixosModules.modulesDesktop = {
    imports = [
      self.nixosModules.modulesDesktopGreetd
      self.nixosModules.modulesDesktopHypr
      self.nixosModules.modulesDesktopLy
      self.nixosModules.modulesDesktopNoctalia
      self.nixosModules.modulesDesktopStylix
      self.nixosModules.modulesDesktopXdg
    ];
    programs.dconf.enable = true;
  };
}
