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
5. All modules use the **flake-parts nixosModules pattern** for registration

## Rationale

### Advantages

1. **Separation of Concerns**
   - Each module handles one feature
   - Easy to locate and modify specific functionality
   - Clear boundaries between components

2. **Host Customization**
   - Different hosts can enable different features
   - No unused code activated on any system
   - Clear what each host uses

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

5. **Automatic Discovery**
   - `import-tree` discovers all `.nix` files automatically
   - No need to manually maintain import lists
   - Add a file, it's available

### Module Pattern

All modules follow a consistent structure using the flake-parts wrapper:

```nix
# The outer function receives flake-parts args
_: {
  # Register as a named NixOS module
  flake.nixosModules.myUniqueModuleName =
    { lib, config, pkgs, ... }:

    {
      options.programs.myFeature = {
        enable = lib.mkEnableOption "Enable my feature";

        optionalPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [];
          description = "Additional packages";
        };
      };

      config = lib.mkIf config.programs.myFeature.enable {
        environment.systemPackages =
          defaultPackages ++ config.programs.myFeature.optionalPackages;
      };
    };
}
```

## Alternatives Considered

### Monolithic Configuration
- **Pros:** Simple, everything in one place
- **Cons:** Hard to maintain, difficult to share between hosts, everything loaded always
- **Rejected:** Doesn't scale beyond single host

### Profile-Based System
- **Pros:** Can compose multiple profiles
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
- No manual import management (import-tree handles discovery)

### Negative
- More files to navigate (many small files vs few large ones)
- Some boilerplate (enable option, mkIf pattern, flake-parts wrapper)
- Module names in `flake.nixosModules` must be unique across the repo

### Neutral
- Directory structure is deeper
- Convention for module naming: `programs.X`, `servicesModule.X`, `hardwareModule.X`
- flake-parts wrapper is required on every module file

## Implementation

### Directory Structure
```
modules/
├── applications/      # User applications
│   ├── dev/
│   │   └── default.nix
│   └── default.nix    # Imports all application modules
├── desktop/           # Desktop environment
├── hardware/          # Hardware option definitions
└── default.nix        # Imports all module categories

core/                  # Always-on system configuration
├── boot/
├── hardware/
├── nix/
├── programs/
└── services/
```

### Host Configuration
```nix
# hosts/{host}/modules/programs.nix
_: {
  flake.nixosModules.host{Host}ModulesPrograms =
    { pkgs, ... }:
    {
      config.programs = {
        gaming.enable = true;
        dev.enable = true;
        content.enable = true;

        dev.optionalPackages = [
          pkgs.some-tool
        ];
      };
    };
}
```

### Host Assembly
```nix
# hosts/{host}/default.nix
{ self, inputs, ... }:
{
  flake.nixosConfigurations.{Host} = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.assets
      self.nixosModules.users{Username}
      self.nixosModules.core
      self.nixosModules.modules
      self.nixosModules.hostCommon
      self.nixosModules.host{Host}Hardware
      self.nixosModules.host{Host}HardwareSpecific
      self.nixosModules.host{Host}Modules
    ];
  };
}
```

### Module Organization Rules

1. **One feature per module** — don't mix gaming and dev tools in one module
2. **Category-based folders** — group related modules (all browsers in `applications/browsing/`)
3. **Enable by default: false** — hosts must explicitly enable features
4. **Provide optionalPackages** — allow extending without forking
5. **Unique module names** — derive from file path to avoid collisions

## Review

This decision should be reviewed if:
- Module count becomes unwieldy
- Pattern causes significant boilerplate
- Better abstractions emerge in NixOS ecosystem
- Inter-module dependencies become complex
