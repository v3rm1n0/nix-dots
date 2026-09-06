# Shared feature defaults for all hosts, overridable per host with plain
# values (mkDefault keeps host definitions winning without mkForce).
{
  flake.modules.nixos.default =
    { lib, ... }:
    {
      mods.security = {
        encryption.passwords.enable = lib.mkDefault true;
        gnupg.enable = lib.mkDefault true;
        ssh.enable = lib.mkDefault true;
        vpn.enable = lib.mkDefault true;
        wazuh.enable = lib.mkDefault false;
      };

      mods.services = {
        blueman.enable = lib.mkDefault true;
        flatpak.enable = lib.mkDefault true;
        vicinae.enable = lib.mkDefault true;
      };

      mods.shell = {
        bash.enable = lib.mkDefault true;
        fish.enable = lib.mkDefault true;
        zsh.enable = lib.mkDefault true;
      };

      mods.desktop = {
        flameshot.enable = lib.mkDefault true;
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
