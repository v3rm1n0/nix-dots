_: {
  flake.modules.nixos.default =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        btop
        resources
      ];
    };
}
