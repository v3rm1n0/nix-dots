{ helium, system, ... }:
{
  browsing = {
    chromium = {
      enable = true;
      package = helium.defaultPackage.${system};
    };
  };
}
