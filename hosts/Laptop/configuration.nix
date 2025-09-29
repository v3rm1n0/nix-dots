{ pkgs, ... }:
{
  imports = [
    ./../../modules
  ];

  programs = {
    comms.enable = true;
    content.enable = false;
    dev.enable = true;
    emulation.enable = true;
    gaming.enable = false;
    media.enable = true;
    office.enable = true;
    terminal.enable = true;
  };

  specs = {
    gpu.enable = true;
    gpu.brand = "intel";
  };
}
