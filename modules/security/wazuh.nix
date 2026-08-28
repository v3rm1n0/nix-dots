{ inputs, ... }:
{
  flake.modules.nixos.default =
    { config, lib, ... }:
    let
      cfg = config.mods.security.wazuh;
    in
    {
      imports = [ inputs.wazuh-agent-nixos.nixosModules.wazuh-agent ];

      options.mods.security.wazuh = {
        enable = lib.mkEnableOption "Wazuh security agent";
      };

      config = lib.mkIf cfg.enable {
        services.wazuh-agent = {
          enable = true;
          manager.host = "172.16.0.102";
          syscheck.directories = [
            "/etc"
            "/boot"
            "/root"
            "/home"
          ];
        };
        systemd.services.wazuh-agent-auth = {
          serviceConfig = {
            Restart = "on-failure";
            RestartSec = "2s";
          };
          startLimitIntervalSec = 60;
          startLimitBurst = 15;
        };
      };
    };
}
