_: {
  flake.nixosModules.modulesSecurityVpn =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.securityModule.vpn;
    in
    {
      options.securityModule.vpn = {
        enable = lib.mkEnableOption "VPN client tools";
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = [ pkgs.proton-vpn ];
      };
    };
}
