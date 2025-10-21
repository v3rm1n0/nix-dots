{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cava
  ];
}
