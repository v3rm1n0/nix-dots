{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.fastfetch = inputs.wrapper-modules.wrappers.fastfetch.wrap {
        inherit pkgs;
        package = pkgs.fastfetch;
        settings = {
          logo = {
            type = "kitty-direct";
            source = "~/.config/nixlogo.png";
            width = 18;
            height = 8;
            padding = {
              top = 1;
            };
          };
          display = {
            separator = "  ";
          };
          modules = [
            "break"
            "title"
            {
              type = "os";
              key = "os    ";
              keyColor = "red";
            }
            {
              type = "kernel";
              key = "kernel";
              keyColor = "green";
            }
            {
              type = "host";
              format = "{vendor} {family}";
              key = "host  ";
              keyColor = "yellow";
            }
            {
              type = "packages";
              key = "pkgs  ";
              keyColor = "blue";
            }
            {
              type = "uptime";
              format = "{?days}{days}d {?}{hours}h {minutes}m";
              key = "uptime";
              keyColor = "magenta";
            }
            {
              type = "memory";
              key = "memory";
              keyColor = "cyan";
            }
            {
              type = "localip";
              key = "localip";
              keyColor = "red";
            }
            "break"
          ];

        };
      };
    };
}
