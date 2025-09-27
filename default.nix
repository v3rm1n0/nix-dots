{
  agenix,
  home-manager,
  stylix,
  username,
  ...
}:
{
  imports = [
    agenix.nixosModules.default
    home-manager.nixosModules.home-manager
    stylix.nixosModules.stylix
    ./assets
    ./hosts
    ./users/${username}
  ];
}
