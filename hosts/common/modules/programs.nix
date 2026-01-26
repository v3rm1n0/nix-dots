{ pkgs, ... }:
{
  config.programs = {
    comms.enable = true;
    content.enable = false;
    dev.enable = true;
    emulation.enable = true;
    gaming = {
      enable = true;
      discordPackage = pkgs.equibop;
    };
    media.enable = true;
    productivity.enable = true;
    terminal.enable = true;
    uni.enable = true;
  };
}
