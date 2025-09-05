{
  agenix,
  home-manager,
  stylix,
  systemType,
  ...
}:
{
  imports = [
    agenix.nixosModules.default
    home-manager.nixosModules.home-manager
    stylix.nixosModules.stylix
    ./profiles/${systemType}.nix
    ./profiles
  ];
}
