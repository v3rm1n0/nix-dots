# dconf is the settings backend GTK apps expect; kept unconditional like the
# rest of the base desktop plumbing (was set by the old desktop aggregator).
{
  flake.modules.nixos.default = {
    programs.dconf.enable = true;
  };
}
