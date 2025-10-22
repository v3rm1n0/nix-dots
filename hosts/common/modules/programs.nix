{ helium, pkgs, system, ... }:
{
  config.programs = {
    browsing = {
      firefox = {
        enable = false;
        package = pkgs.librewolf;
      };
      chromium = {
        enable = true;
        package = helium.defaultPackage.${system};
      };
      tor.enable = false;
    };
    comms.enable = true;
    content.enable = false;
    dev.enable = true;
    emulation.enable = true;
    gaming.enable = true;
    media.enable = true;
    productivity.enable = true;
    terminal.enable = true;
    uni.enable = true;
  };
}
