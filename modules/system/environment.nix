_: {
  flake.modules.nixos.default = {
    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        WEBKIT_DISABLE_COMPOSITING_MODE = "1";
      };
    };
  };
}
