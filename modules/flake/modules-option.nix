{ lib, ... }:
{
  # Mergeable per-class module registry (dendritic pattern): any number of
  # files may define the same `flake.modules.<class>.<name>` and the
  # definitions merge into a single module. Drop this declaration if
  # flake-parts ever ships a native `flake.modules` option.
  options.flake.modules = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.deferredModule);
    default = { };
  };
}
