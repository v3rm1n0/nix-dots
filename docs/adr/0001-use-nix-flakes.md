# ADR 0001: Use Nix Flakes

**Status:** Accepted

**Date:** 2024

## Context

NixOS configurations can be managed using traditional channels or the newer Flakes system. We needed to choose an approach for managing dependencies and ensuring reproducibility across multiple machines.

## Decision

We will use Nix Flakes for this configuration.

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

### Disadvantages (Accepted)

1. **Still Experimental**
   - Flakes are marked as experimental
   - Requires `--experimental-features "nix-command flakes"`
   - May have breaking changes (though unlikely now)

2. **Learning Curve**
   - Different mental model than channels
   - Requires understanding of flake outputs
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

### Negative
- Users must enable experimental features
- Some documentation assumes channel-based setup
- Slightly more complex initial setup

### Neutral
- Commits must update `flake.lock` when dependencies change
- Regular `nix flake update` needed to get security updates

## Implementation

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # ... other inputs
  };

  outputs = inputs: {
    nixosConfigurations = {
      Desktop = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; } // inputs;
        modules = [ ./. ./hosts/Desktop ];
      };
    };
  };
}
```

## Review

This decision should be reviewed if:
- Flakes are deprecated or replaced
- A better dependency management system emerges
- The experimental status causes significant issues
