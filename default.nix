{
  agenix,
  home-manager,
  stylix,
  ...
}:
{
  imports = [
    agenix.nixosModules.default
    home-manager.nixosModules.home-manager
    stylix.nixosModules.stylix
    ./assets
  ];
}
