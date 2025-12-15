{ helium, system, ... }:
{
  config.programs = {
    browsing = {
      chromium = {
        enable = true;
        package = helium.packages.${system}.default;
      };
    };
  };
}
