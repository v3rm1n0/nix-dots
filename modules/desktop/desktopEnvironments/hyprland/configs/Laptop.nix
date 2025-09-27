{ lib, config, ... }:
{
  config.monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      refreshRate = 180;
      x = 0;
      y = 0;
      workspaces = [
        1
        2
        3
        4
        5
        6
        7
        8
        9
      ];
      workspacePrimary = 1;
      enabled = true;
    }
    {
      name = "";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      x = 1920;
      y = 0;
      workspaces = [ 10 ];
      workspacePrimary = 10;
      enabled = true;
    }
  ];
}
