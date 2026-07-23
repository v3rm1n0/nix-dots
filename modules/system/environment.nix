_: {
  flake.modules.nixos.default = {
    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        PROTON_PASS_KEY_PROVIDER = "fs";
        WEBKIT_DISABLE_COMPOSITING_MODE = "1";
      };
    };
  };
}
