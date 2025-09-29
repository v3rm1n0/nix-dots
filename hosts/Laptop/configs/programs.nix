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
      ];
    };
    emulation.enable = false;
    gaming.enable = true;
    media.enable = true;
    office.enable = true;
    terminal.enable = true;
  };
}
