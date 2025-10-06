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
    productivity.enable = true;
    terminal.enable = true;
    uni.enable = true;
  };
}
