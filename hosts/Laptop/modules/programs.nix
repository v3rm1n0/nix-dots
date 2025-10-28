{ helium, system, ... }:
{
  config.browsing = {
    chromium = {
      enable = true;
      package = helium.defaultPackage.${system};
    };
  };
}
