_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.mods.security.encryption.passwords = {
        enable = lib.mkEnableOption "Enable passwords module";
      };

      config = lib.mkIf config.mods.security.encryption.passwords.enable {
        environment = {
          systemPackages = with pkgs; [
            bitwarden-desktop
            proton-authenticator
          ];
        };
      };
    };
}
