{ pkgs, ... }:
{
  imports = [
    ./../../modules
  ];

  programs = {
    comms.enable = true;
    content.enable = false;
    emulation.enable = true;
    gaming.enable = true;
    media.enable = true;
    office.enable = true;
    terminal.enable = true;
  };

  devTools.enable = true;
  devTools.optionalPackages = [
    pkgs.zed-editor
  ];

  specs = {
    gpu.enable = true;
    gpu.brand = "nvidia";
  };
}
