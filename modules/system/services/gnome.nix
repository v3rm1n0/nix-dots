_: {
  flake.modules.nixos.default = {
    services.gnome.gnome-keyring = {
      enable = true;
    };
  };
}
