{
  config,
  lib,
  pkgs,
  username,
  ...
}:
{
  options.programs.emulation = {
    enable = lib.mkEnableOption "Enabled the emulation programs";
  };

  config = lib.mkIf config.programs.emulation.enable {
    home-manager.users.${username}.home.packages = with pkgs; [
      qemu
      quickemu
    ];
    programs.virt-manager.enable = true;
    users.users.${username}.extraGroups = [ "libvirtd" ];
    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };
  };
}
