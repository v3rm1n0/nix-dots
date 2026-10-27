_: {
  flake.modules.nixos.default =
    { pkgs, ... }:
    {
      environment = {
        sessionVariables = {
          NIXOS_OZONE_WL = "1";
          PROTON_PASS_KEY_PROVIDER = "fs";
          WEBKIT_DISABLE_COMPOSITING_MODE = "1";
          GIO_EXTRA_MODULES = [ "${pkgs.glib-networking}/lib/gio/modules" ];
        };
      };
    };
}
