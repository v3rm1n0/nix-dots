_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.mods.security.vpn;
    in
    {
      options.mods.security.vpn = {
        enable = lib.mkEnableOption "VPN client tools";
      };

      config = lib.mkIf cfg.enable {
        services.ivpn.enable = true;
        environment.systemPackages = [
          pkgs.ivpn
          pkgs.wireguard-tools
        ];
      };
    };
}
