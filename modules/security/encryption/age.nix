{
  agenix,
  config,
  lib,
  system,
  ...
}:
let
  username = config.userOptions.username;
in
{
  options.securityModule.encryption.age = {
    enable = lib.mkEnableOption "Enable age module";
  };

  config = lib.mkIf config.securityModule.encryption.age.enable {
    environment.systemPackages = [
      agenix.packages."${system}".default
    ];
    
    age = {
      identityPaths = [
        "/home/${username}/.ssh/agenix_key"
      ];
      secrets = {
        weatherAPI = {
          file = ../../../secrets/weatherAPI.age;
          owner = username;
        };
        rclone_conf = {
          file = ../../../secrets/rclone_conf.age;
          owner = username;
        };
      };
    };
  };
}
