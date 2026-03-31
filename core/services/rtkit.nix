_: {
  flake.nixosModules.coreServicesRtkit = {
    security.rtkit.enable = true;
  };
}
