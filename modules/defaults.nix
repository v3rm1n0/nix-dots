# Shared feature defaults for all hosts, overridable per host with plain
# values (mkDefault keeps host definitions winning without mkForce).
{
  flake.modules.nixos.default =
    { lib, ... }:
    {
      mods.desktop = {
        hypr.enable = lib.mkDefault true;
        ly.enable = lib.mkDefault true;
        noctalia.enable = lib.mkDefault true;
        stylix.enable = lib.mkDefault true;
        xdg.enable = lib.mkDefault true;
      };

      mods.apps = {
        comms.enable = lib.mkDefault true;
        content.enable = lib.mkDefault false;
        dev.enable = lib.mkDefault true;
        emulators.enable = lib.mkDefault true;
        gaming.enable = lib.mkDefault true;
        media.enable = lib.mkDefault true;
        productivity.enable = lib.mkDefault true;
        terminal.enable = lib.mkDefault true;
        uni.enable = lib.mkDefault true;
      };
    };
}
