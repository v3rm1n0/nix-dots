{ lib, ... }:

{
  options.userOptions = {
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
