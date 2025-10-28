{ config, lib, ... }:

{
  options.userOptions = {
    browser = lib.mkOption {
      type = lib.types.str;
      description = "The browser cli name to use as default browser. (Should match the browser defined in the browser module)";
    };

    colorScheme = lib.mkOption {
      type = lib.types.str;
      description = "The base16 scheme name for stylix.";
    };

    dots = lib.mkOption {
      type = lib.types.str;
      description = "The absolute path to the flake location e.g. /etc/nixos.";
    };

    hostName = lib.mkOption {
      type = lib.types.str;
      description = "The hostname for the system.";
    };

    username = lib.mkOption {
      type = lib.types.str;
      description = "The main user's username.";
    };

    wallpaper = lib.mkOption {
      type = lib.types.str;
      description = "The wallpaper filename.";
    };
  };
}
