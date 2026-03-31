# ADR 0001: Use Nix Flakes

**Status:** Accepted

**Date:** 2024

## Context

NixOS configurations can be managed using traditional channels or the newer Flakes system. We needed to choose an approach for managing dependencies and ensuring reproducibility across multiple machines.

## Decision

We will use Nix Flakes for this configuration, combined with **flake-parts** for structuring flake outputs and **import-tree** for automatic module discovery.

## Rationale

### Advantages of Flakes

1. **Reproducibility**
   - `flake.lock` pins all dependencies to specific commits
   - Ensures identical builds across machines and time
   - No "it works on my machine" issues

2. **Explicit Dependencies**
   - All inputs declared in `flake.nix`
   - Clear dependency graph
   - Easy to see what external projects we depend on

3. **Modern Tooling**
   - Better CLI experience (`nix run`, `nix develop`)
   - Standardized structure (`nixosConfigurations` output)
   - Growing ecosystem adoption

4. **Follows Pattern**
   - All inputs follow `nixpkgs` to prevent version conflicts
   - Reduces binary cache misses
   - Simpler dependency resolution

### flake-parts + import-tree

Using **flake-parts** allows each module file to contribute to the flake outputs (`flake.nixosModules.*`) directly, rather than relying on a top-level aggregation file. **import-tree** automatically discovers all `.nix` files in configured directories, eliminating manual import management.

### Disadvantages (Accepted)

1. **Still Experimental**
   - Flakes are marked as experimental
   - Requires `--experimental-features "nix-command flakes"`
   - May have breaking changes (though unlikely now)

2. **Learning Curve**
   - Different mental model than channels
   - Requires understanding of flake outputs and flake-parts conventions
   - More complex for beginners

## Alternatives Considered

### Traditional Channels
- **Pros:** Stable, well-documented, simpler
- **Cons:** Less reproducible, implicit dependencies, harder to pin versions
- **Rejected:** Reproducibility is critical for this use case

### Niv + Legacy Nix
- **Pros:** More stable than Flakes, better than raw channels
- **Cons:** Extra tool, less standardized, being superseded by Flakes
- **Rejected:** Flakes is the future, better to adopt now

## Consequences

### Positive
- Configuration is fully reproducible
- Easy to test new package versions without channel updates
- Can use community flakes directly (Stylix, Home Manager, etc.)
- Lock file makes rollbacks reliable
- `import-tree` removes the need to manually maintain import lists

### Negative
- Users must enable experimental features
- Some documentation assumes channel-based setup
- Slightly more complex initial setup
- Each module file must use the flake-parts wrapper pattern

### Neutral
- Commits must update `flake.lock` when dependencies change
- Regular `nix flake update` needed to get security updates

## Implementation

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # ... other inputs
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        imports = [
          (inputs.import-tree ./assets)
          (inputs.import-tree ./core)
          (inputs.import-tree ./hosts)
          (inputs.import-tree ./modules)
          (inputs.import-tree ./users)
        ];
      }
    );
}
```

Each module file contributes to the flake via the flake-parts module system:

```nix
# modules/applications/myapp/default.nix
_: {
  flake.nixosModules.modulesApplicationsMyapp =
    { lib, config, pkgs, ... }:
    {
      options.programs.myapp.enable = lib.mkEnableOption "Enable MyApp";
      config = lib.mkIf config.programs.myapp.enable {
        environment.systemPackages = [ pkgs.myapp ];
      };
    };
}
```

## Review

This decision should be reviewed if:
- Flakes are deprecated or replaced
- A better dependency management system emerges
- The experimental status causes significant issues
