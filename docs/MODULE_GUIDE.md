# Module Development Guide

This guide provides detailed information about creating, maintaining, and understanding modules in this NixOS configuration.

## Table of Contents

- [Module Basics](#module-basics)
- [Module Categories](#module-categories)
- [Creating a New Module](#creating-a-new-module)
- [Module Patterns](#module-patterns)
- [Integration Points](#integration-points)
- [Examples](#examples)
- [Best Practices](#best-practices)
- [Testing](#testing)

## Module Basics

### What is a Module?

In NixOS, a module is a Nix file that:
1. Defines configuration **options** (what can be configured)
2. Provides **config** values (the actual configuration when enabled)
3. Can **import** other modules

### Module Structure

Every module in this configuration uses the **flake-parts nixosModules pattern**. Each file is wrapped in a flake-parts module that registers it as a named NixOS module:

```nix
# The outer function receives flake-parts args (unused here, hence _)
_: {
  # Register this as a named NixOS module in the flake
  flake.nixosModules.myUniqueName =
    { lib, config, pkgs, ... }:

    let
      cfg = config.programs.myFeature;
    in
    {
      # Define what can be configured
      options.programs.myFeature = {
        enable = lib.mkEnableOption "Enable my feature";

        # Additional options...
      };

      # Define the actual configuration when enabled
      config = lib.mkIf cfg.enable {
        environment.systemPackages = [ pkgs.mypackage ];

        # Additional configuration...
      };
    };
}
```

The `flake.nixosModules.<name>` key must be **unique across the entire repository**. Use a name derived from the file's path (e.g., `modulesApplicationsMyapp`, `hostDesktopModulesPrograms`).

## Module Categories

This configuration organizes modules into categories:

### `modules/applications/`
User-facing applications and tools.

**Examples:** browsers, development tools, gaming, productivity apps

**Naming convention:** `programs.<feature>`

### `modules/desktop/`
Desktop environment components.

**Examples:** Hyprland, Stylix, login managers, XDG portals

### `modules/hardware/`
Hardware-specific option definitions.

**Examples:** GPU options, Razer peripheral support

**Naming convention:** `hardwareModule.<feature>`

### `modules/security/`
Security-related features.

**Examples:** GPG, password managers, authentication, VPN

### `modules/services/`
User-level services.

**Examples:** Bluetooth, Flatpak, custom services

**Naming convention:** `servicesModule.<feature>`

### `modules/shell/`
Shell configuration.

**Examples:** Zsh, Bash, aliases, prompts

### `modules/user/`
User options system — defines the `userOptions` interface used throughout.

### `core/`
Core system configuration (always enabled, not gated by options).

**Examples:** Boot, hardware drivers, Nix settings, system services

## Creating a New Module

### Step 1: Determine Category

Ask yourself:
- Is this an application users interact with? → `modules/applications/`
- Is this part of the desktop environment? → `modules/desktop/`
- Does this define hardware options? → `modules/hardware/`
- Is this a security feature? → `modules/security/`
- Is this a background service? → `modules/services/`
- Is this shell-related? → `modules/shell/`
- Is this core system functionality? → `core/` (probably always enabled)

### Step 2: Create Module File

```bash
mkdir -p modules/applications/myapp
# Write modules/applications/myapp/default.nix
```

`import-tree` will discover it automatically — no manual import needed.

### Step 3: Write Module

```nix
# modules/applications/myapp/default.nix
_: {
  flake.nixosModules.modulesApplicationsMyapp =
    { lib, config, pkgs, ... }:

    let
      cfg = config.programs.myapp;
    in
    {
      options.programs.myapp = {
        enable = lib.mkEnableOption "Enable MyApp";

        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.myapp;
          description = "The MyApp package to use.";
        };
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = [ cfg.package ];

        # Optional: Home Manager configuration
        home-manager.users.${config.userOptions.username} = {
          programs.myapp.enable = true;
        };
      };
    };
}
```

### Step 4: Enable in Host Config

```nix
# hosts/{host}/modules/programs.nix
programs.myapp.enable = true;
```

### Step 5: Test

```bash
# Check syntax
nix flake check

# Build without switching
sudo nixos-rebuild build --flake .#{host}

# Test (temporary activation)
sudo nixos-rebuild test --flake .#{host}

# If working, make permanent
sudo nixos-rebuild switch --flake .#{host}
```

## Module Patterns

### Pattern 1: Simple Package Installation

```nix
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

### Pattern 2: Package List with Optional Additions

```nix
_: {
  flake.nixosModules.modulesApplicationsMyfeature =
    { lib, config, pkgs, ... }:

    let
      cfg = config.programs.myfeature;
      defaultPackages = [ pkgs.core-tool pkgs.important-tool ];
    in
    {
      options.programs.myfeature = {
        enable = lib.mkEnableOption "Enable my feature";

        optionalPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Additional packages to install alongside the defaults.";
        };
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = defaultPackages ++ cfg.optionalPackages;
      };
    };
}
```

Usage:
```nix
programs.myfeature = {
  enable = true;
  optionalPackages = [ pkgs.extra-tool ];
};
```

### Pattern 3: Configurable Package

```nix
_: {
  flake.nixosModules.modulesApplicationsMyapp =
    { lib, config, pkgs, ... }:

    let
      cfg = config.programs.myapp;
    in
    {
      options.programs.myapp = {
        enable = lib.mkEnableOption "Enable MyApp";

        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.myapp;
          description = "The MyApp package to use.";
        };
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = [ cfg.package ];
      };
    };
}
```

Usage:
```nix
programs.myapp = {
  enable = true;
  package = pkgs.myapp-beta;
};
```

### Pattern 4: Home Manager Integration

```nix
_: {
  flake.nixosModules.modulesApplicationsMyapp =
    { lib, config, pkgs, ... }:

    let
      cfg = config.programs.myapp;
      username = config.userOptions.username;
    in
    {
      options.programs.myapp = {
        enable = lib.mkEnableOption "Enable MyApp";

        settings = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = "MyApp configuration settings.";
        };
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = [ pkgs.myapp ];

        home-manager.users.${username} = {
          programs.myapp = {
            enable = true;
            settings = cfg.settings;
          };
        };
      };
    };
}
```

### Pattern 5: Module with Multiple Sub-features

```nix
_: {
  flake.nixosModules.modulesApplicationsMyapp =
    { lib, config, pkgs, ... }:

    let
      cfg = config.programs.myapp;
    in
    {
      options.programs.myapp = {
        enable = lib.mkEnableOption "Enable MyApp";
        enableExtensions = lib.mkEnableOption "Enable extensions";
        enableSync = lib.mkEnableOption "Enable sync feature";
      };

      config = lib.mkMerge [
        (lib.mkIf cfg.enable {
          environment.systemPackages = [ pkgs.myapp ];
        })

        (lib.mkIf (cfg.enable && cfg.enableExtensions) {
          environment.systemPackages = [ pkgs.myapp-extensions ];
        })

        (lib.mkIf (cfg.enable && cfg.enableSync) {
          services.myapp-sync.enable = true;
        })
      ];
    };
}
```

### Pattern 6: Module with External Flake Inputs

When a module needs inputs from the flake (e.g., a flake-provided Home Manager module):

```nix
{ inputs, self, ... }: {
  flake.nixosModules.modulesDesktopMyWM =
    { config, pkgs, ... }:

    let
      username = config.userOptions.username;
    in
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        self.nixosModules.someOtherModule
      ];

      # ... rest of module
    };
}
```

## Integration Points

### Accessing User Options

User-configured options are available via `config.userOptions`:

```nix
let
  username = config.userOptions.username;
  browser = config.userOptions.browser;
  colorScheme = config.userOptions.colorScheme;
  wallpaper = config.userOptions.wallpaper;
  hostname = config.userOptions.hostName;
  dots = config.userOptions.dots;
in
```

### Accessing Hardware Config

Hardware configuration is in `config.hardwareModule`:

```nix
let
  gpuBrand = config.hardwareModule.gpu.brand;
  gpuEnabled = config.hardwareModule.gpu.enable;
in
{
  config = lib.mkIf (gpuEnabled && gpuBrand == "nvidia") {
    # NVIDIA-specific configuration
  };
}
```

### Monitor Configuration

Monitors are configured in `config.monitors` (defined per host):

```nix
let
  monitors = config.monitors;
in
{
  # Example: use monitor names
  services.my-service.monitors = map (m: m.name) monitors;
}
```

### Styling via Stylix

Stylix applies colors automatically. Access base16 colors if needed:

```nix
let
  inherit (config.lib.stylix.colors) base00 base0A;
in
```

## Examples

### Example 1: Simple Application Module

```nix
# modules/applications/media/vlc/default.nix
_: {
  flake.nixosModules.modulesApplicationsMediaVlc =
    { lib, config, pkgs, ... }:
    {
      options.programs.media.vlc.enable =
        lib.mkEnableOption "Enable VLC media player";

      config = lib.mkIf config.programs.media.vlc.enable {
        environment.systemPackages = [ pkgs.vlc ];
      };
    };
}
```

### Example 2: Service Module

```nix
# modules/services/syncthing/default.nix
_: {
  flake.nixosModules.modulesServicesSyncthing =
    { lib, config, ... }:

    let
      cfg = config.servicesModule.syncthing;
      username = config.userOptions.username;
    in
    {
      options.servicesModule.syncthing = {
        enable = lib.mkEnableOption "Enable Syncthing file sync";

        dataDir = lib.mkOption {
          type = lib.types.str;
          default = "/home/${username}/Sync";
          description = "Directory to sync.";
        };
      };

      config = lib.mkIf cfg.enable {
        services.syncthing = {
          enable = true;
          user = username;
          dataDir = cfg.dataDir;
        };
      };
    };
}
```

### Example 3: Hardware Module

```nix
# modules/hardware/custom/default.nix
_: {
  flake.nixosModules.modulesHardwareCustom =
    { lib, ... }:
    {
      options.hardwareModule.myDevice = {
        enable = lib.mkEnableOption "Enable my device support";

        model = lib.mkOption {
          type = lib.types.enum [ "modelA" "modelB" ];
          default = "modelA";
          description = "Device model for specific optimizations.";
        };
      };
    };
}
```

## Best Practices

### 1. Always Use the flake-parts Wrapper

Every `.nix` file must use the outer `_: { flake.nixosModules.<name> = ...; }` structure:

```nix
# Correct
_: {
  flake.nixosModules.myModule =
    { lib, config, pkgs, ... }:
    { ... };
}

# Wrong — import-tree won't register this correctly
{ lib, config, pkgs, ... }:
{ ... }
```

### 2. Use Unique Module Names

Derive names from the file path to avoid collisions:
- `modules/applications/gaming/default.nix` → `modulesApplicationsGaming`
- `core/nix/btrfs.nix` → `coreNixBtrfs`

### 3. Use `lib.mkEnableOption`

```nix
# Good
enable = lib.mkEnableOption "Enable my feature";

# Avoid
enable = lib.mkOption { type = lib.types.bool; default = false; };
```

### 4. Provide Sensible Defaults

```nix
package = lib.mkOption {
  type = lib.types.package;
  default = pkgs.myapp;
  description = "Package to use.";
};
```

### 5. Document Options

```nix
optionalPackages = lib.mkOption {
  type = lib.types.listOf lib.types.package;
  default = [ ];
  example = lib.literalExpression "[ pkgs.extra-tool ]";
  description = ''
    Additional packages to install alongside the defaults.
  '';
};
```

### 6. Use Types Correctly

```nix
type = lib.types.str;                           # Strings
type = lib.types.int;                           # Integers
type = lib.types.bool;                          # Booleans
type = lib.types.package;                       # Packages
type = lib.types.listOf lib.types.package;      # List of packages
type = lib.types.enum [ "opt1" "opt2" ];        # Enum
type = lib.types.nullOr lib.types.str;          # Nullable string
type = lib.types.attrs;                         # Attribute set
```

### 7. Prefer Declarative Over Imperative

```nix
# Prefer
config = lib.mkIf cfg.enable {
  systemd.tmpfiles.rules = [
    "d /some/path 0755 root root -"
  ];
};

# Avoid
config = lib.mkIf cfg.enable {
  system.activationScripts.setup = ''
    mkdir -p /some/path
  '';
};
```

## Testing

### Testing Workflow

1. **Syntax Check:**
   ```bash
   nix flake check
   ```

2. **Build Only:**
   ```bash
   sudo nixos-rebuild build --flake .#{host}
   ```

3. **Test Configuration:**
   ```bash
   sudo nixos-rebuild test --flake .#{host}
   ```

4. **Verify Feature:**
   ```bash
   which myapp
   systemctl status my-service
   ```

5. **Make Permanent:**
   ```bash
   sudo nixos-rebuild switch --flake .#{host}
   ```

6. **Rollback if Needed:**
   ```bash
   sudo nixos-rebuild switch --rollback
   ```

### Testing Checklist

- [ ] Module builds successfully with `nix flake check`
- [ ] Packages are installed when enabled
- [ ] Services start correctly (if applicable)
- [ ] Configuration files are generated correctly
- [ ] Module works with different hosts
- [ ] Disabling module removes everything cleanly
- [ ] `flake.nixosModules.<name>` is unique

## Troubleshooting

### Module Not Loading

Check that the module name is referenced in the host's `default.nix`:
```bash
grep -r "myModuleName" hosts/
```

Check that `import-tree` can discover the file (must be `.nix` and in a scanned directory).

### Option Conflicts

**Error:** "The option `X` is defined multiple times"

**Fix:** Use `lib.mkDefault` for defaults, `lib.mkForce` to override:
```nix
programs.myapp.setting = lib.mkDefault "default-value";
# or
programs.myapp.setting = lib.mkForce "override-value";
```

### Type Errors

**Error:** "value is a X while a Y was expected"

Match the option type to the provided value:
```nix
# types.str → use a string
programs.myapp.setting = "string-value";

# types.int → use a number
programs.myapp.count = 5;
```

## Further Reading

- [NixOS Module System Documentation](https://nixos.org/manual/nixos/stable/#sec-writing-modules)
- [flake-parts Documentation](https://flake.parts/)
- [Architecture Documentation](./ARCHITECTURE.md)
- [Contributing Guide](../CONTRIBUTING.md)
