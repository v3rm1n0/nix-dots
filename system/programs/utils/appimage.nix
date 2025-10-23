{ config, lib, ... }:
{
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
