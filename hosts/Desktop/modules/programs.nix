{
  helium,
  pkgs,
  system,
  ...
}:
{
  config.programs = {
    browsing = {
      chromium = {
        enable = false;
        package = helium.packages.${system}.default;
      };
      firefox = {
        enable = true;
        package = pkgs.librewolf;
      };
    };
    dev.optionalPackages = [
      pkgs.zed-editor
    ];
  };
}
