{ self, inputs, ... }:
{
  flake.nixosModules.coreBootPlymouth = {
    boot.plymouth = {
      enable = true;
    };
  };
}
