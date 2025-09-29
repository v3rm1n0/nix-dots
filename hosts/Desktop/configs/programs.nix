{ pkgs, ... }:
{
  imports = [
    ./../../../modules
  ];

  programs = {
    comms.enable = true;
    content.enable = false;
    dev = {
      enable = true;
      optionalPackages = [
        pkgs.zed-editor
      ];
    };
    emulation.enable = true;
    gaming.enable = true;
    media.enable = true;
    office.enable = true;
    terminal.enable = true;
    uni.enable = true;
  };
}
