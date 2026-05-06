{ self, ... }:
{
  flake.nixosModules.modulesSecurity = {
    imports = [
      self.nixosModules.modulesSecurityAuth
      self.nixosModules.modulesSecurityEncryption
      self.nixosModules.modulesSecurityGnupg
      self.nixosModules.modulesSecuritySsh
      self.nixosModules.modulesSecuritySudo
      self.nixosModules.modulesSecurityVpn
    ];
  };
}
