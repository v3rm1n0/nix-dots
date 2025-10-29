# ADR 0002: Modular Architecture with Enable Options

**Status:** Accepted

**Date:** 2024

## Context

NixOS configurations can become monolithic and difficult to maintain. We needed a strategy to organize code for multiple hosts with different requirements while keeping the configuration maintainable and easy to understand.

## Decision

We will use a modular architecture where:
1. Each feature is a separate module with an `enable` option
2. Modules are organized by category (applications, desktop, hardware, security, services)
3. Host configurations only enable the modules they need
4. Common configuration is shared via `hosts/common/`

## Rationale

### Advantages

1. **Separation of Concerns**
   - Each module handles one feature
   - Easy to locate and modify specific functionality
   - Clear boundaries between components

2. **Host Customization**
   - Desktop can enable gaming and NVIDIA drivers
   - Laptop can enable power management and Intel graphics
   - No unused code activated on either system

3. **Maintainability**
   - Changes to one module don't affect others
   - Easy to add/remove features
   - Clear ownership of code sections

4. **Readability**
   ```nix
   # Clear intent in host config
   config.programs = {
     gaming.enable = true;
     dev.enable = true;
   };
   ```

5. **Testability**
   - Can test individual modules
   - Easy to disable problematic modules temporarily
   - Reduce surface area when debugging

### Module Pattern

All modules follow a consistent structure:

```nix
{ lib, config, pkgs, ... }:

with lib;

{
  options.programs.myFeature = {
    enable = mkEnableOption "Enable my feature";

    optionalPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional packages";
    };
  };

  config = mkIf config.programs.myFeature.enable {
    environment.systemPackages = defaultPackages ++ config.programs.myFeature.optionalPackages;
  };
}
```

## Alternatives Considered

### Monolithic Configuration
- **Pros:** Simple, everything in one place
- **Cons:** Hard to maintain, difficult to share between hosts, everything loaded always
- **Rejected:** Doesn't scale beyond single host

### Profile-Based System
- **Pros:** Can compose multiple profiles (e.g., "desktop" + "gaming")
- **Cons:** Less granular, profiles can conflict, harder to see what's enabled
- **Rejected:** Enable options provide finer control

### Separate Repositories per Host
- **Pros:** Complete isolation
- **Cons:** Hard to share code, duplicated effort, harder to maintain
- **Rejected:** Want to share common configuration

## Consequences

### Positive
- Easy to understand what each host enables
- New hosts can be created by enabling relevant modules
- Can disable individual features for debugging
- Clear code organization makes contributions easier
- Module reuse reduces duplication

### Negative
- More files to navigate (many small files vs few large ones)
- Need to remember to import new modules in parent `default.nix`
- Some boilerplate (enable option, mkIf pattern)

### Neutral
- Directory structure is deeper
- Need convention for module naming (we use `programs.X`, `servicesModule.X`, `hardwareModule.X`)

## Implementation

### Directory Structure
```
modules/
├── applications/      # User applications
│   ├── dev/
│   │   └── default.nix
│   └── default.nix    # Imports all application modules
├── desktop/           # Desktop environment
├── hardware/          # Hardware support
└── default.nix        # Imports all module categories
```

### Host Configuration
```nix
# hosts/Desktop/modules/programs.nix
{
  config.programs = {
    gaming.enable = true;
    dev.enable = true;
    content.enable = true;
  };

  config.programs.dev.optionalPackages = [
    pkgs.jetbrains.idea-ultimate
  ];
}
```

### Module Organization Rules

1. **One feature per module** - Don't mix gaming and dev tools in one module
2. **Category-based folders** - Group related modules (all browsers in `applications/browsing/`)
3. **Enable by default: false** - Hosts must explicitly enable features
4. **Provide optionalPackages** - Allow extending without forking
5. **Document options** - Use `description` field

## Migration Path

When refactoring existing configuration:
1. Identify distinct features
2. Create module file with enable option
3. Move configuration into `config = mkIf ...` block
4. Add import in parent `default.nix`
5. Enable in host config
6. Test with `nixos-rebuild test`

## Review

This decision should be reviewed if:
- Module count becomes unwieldy (>50 modules)
- Pattern causes significant boilerplate
- Better abstractions emerge in NixOS ecosystem
- Inter-module dependencies become complex
