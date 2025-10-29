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

Every module in this configuration follows this pattern:

```nix
{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.programs.myFeature;
in
{
  # Define what can be configured
  options.programs.myFeature = {
    enable = mkEnableOption "Enable my feature";

    # Additional options...
  };

  # Define the actual configuration when enabled
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.mypackage ];

    # Additional configuration...
  };
}
```

## Module Categories

This configuration organizes modules into categories:

### `modules/applications/`
User-facing applications and tools.

**Examples:** browsers, development tools, gaming, productivity apps

**Naming:** `programs.<feature>`

**Purpose:** Install and configure end-user applications

### `modules/desktop/`
Desktop environment components.

**Examples:** Hyprland, Stylix, login managers, XDG portals

**Naming:** Various (WM-specific, theming)

**Purpose:** Configure the graphical environment

### `modules/hardware/`
Hardware-specific support.

**Examples:** GPU drivers, Razer peripherals, graphics configuration

**Naming:** `hardwareModule.<feature>`

**Purpose:** Enable and configure hardware support

### `modules/security/`
Security-related features.

**Examples:** GPG, agenix, password managers, authentication

**Naming:** Various (security-specific)

**Purpose:** Security tools and encryption

### `modules/services/`
User-level services.

**Examples:** Bluetooth, Flatpak, Tailscale, custom services

**Naming:** `servicesModule.<feature>`

**Purpose:** Background services and daemons

### `modules/shell/`
Shell configuration.

**Examples:** Zsh, Bash, aliases, prompts

**Naming:** Shell-specific

**Purpose:** Configure command-line environment

### `modules/user/`
User options system.

**Purpose:** Define user-configurable options (username, theme, etc.)

### `system/`
Core system configuration (not optional features).

**Examples:** Boot, hardware, Nix settings, system services

**Purpose:** Essential system functionality

## Creating a New Module

### Step 1: Determine Category

Ask yourself:
- Is this an application users interact with? → `modules/applications/`
- Is this part of the desktop environment? → `modules/desktop/`
- Does this enable hardware? → `modules/hardware/`
- Is this a security feature? → `modules/security/`
- Is this a background service? → `modules/services/`
- Is this shell-related? → `modules/shell/`
- Is this core system functionality? → `system/` (and it's probably always enabled)

### Step 2: Create Module File

```bash
# Example: Creating a new browser module
mkdir -p modules/applications/browsing/brave
touch modules/applications/browsing/brave/default.nix
```

### Step 3: Write Module

```nix
# modules/applications/browsing/brave/default.nix
{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.programs.browsing.brave;
in
{
  options.programs.browsing.brave = {
    enable = mkEnableOption "Enable Brave browser";

    package = mkOption {
      type = types.package;
      default = pkgs.brave;
      description = "The Brave package to use";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Optional: Home Manager configuration
    home-manager.users.${config.userOptions.username} = {
      programs.brave = {
        enable = true;
        # Browser-specific settings...
      };
    };
  };
}
```

### Step 4: Add Import

Add your module to the parent `default.nix`:

```nix
# modules/applications/browsing/default.nix
{
  imports = [
    ./firefox.nix
    ./chromium.nix
    ./brave  # Add your new module
  ];
}
```

### Step 5: Enable in Host Config

```nix
# hosts/Desktop/modules/programs.nix
{
  config.programs.browsing.brave.enable = true;
}
```

### Step 6: Test

```bash
# Check syntax
nix flake check

# Build without switching
sudo nixos-rebuild build --flake .#Desktop

# Test (temporary activation)
sudo nixos-rebuild test --flake .#Desktop

# If working, make permanent
sudo nixos-rebuild switch --flake .#Desktop
```

## Module Patterns

### Pattern 1: Simple Package Installation

For modules that just install packages:

```nix
{ lib, config, pkgs, ... }:

with lib;

{
  options.programs.myapp.enable = mkEnableOption "Enable MyApp";

  config = mkIf config.programs.myapp.enable {
    environment.systemPackages = [ pkgs.myapp ];
  };
}
```

### Pattern 2: Package List with Optional Additions

For modules with default packages and optional extras:

```nix
{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.programs.myfeature;

  defaultPackages = [
    pkgs.core-tool
    pkgs.important-tool
  ];
in
{
  options.programs.myfeature = {
    enable = mkEnableOption "Enable my feature";

    optionalPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Additional packages to install";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = defaultPackages ++ cfg.optionalPackages;
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

For modules where the package itself can be changed:

```nix
{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.programs.myapp;
in
{
  options.programs.myapp = {
    enable = mkEnableOption "Enable MyApp";

    package = mkOption {
      type = types.package;
      default = pkgs.myapp;
      description = "The MyApp package to use";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
```

Usage:
```nix
programs.myapp = {
  enable = true;
  package = pkgs.myapp-beta;  # Use different version
};
```

### Pattern 4: Home Manager Integration

For modules that configure both system and user:

```nix
{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.programs.myapp;
  username = config.userOptions.username;
in
{
  options.programs.myapp = {
    enable = mkEnableOption "Enable MyApp";

    settings = mkOption {
      type = types.attrs;
      default = { };
      description = "MyApp configuration settings";
    };
  };

  config = mkIf cfg.enable {
    # System-level config
    environment.systemPackages = [ pkgs.myapp ];

    # User-level config via Home Manager
    home-manager.users.${username} = {
      programs.myapp = {
        enable = true;
        settings = cfg.settings;
      };
    };
  };
}
```

### Pattern 5: Conditional Features

For modules with optional sub-features:

```nix
{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.programs.myapp;
in
{
  options.programs.myapp = {
    enable = mkEnableOption "Enable MyApp";

    enableExtensions = mkEnableOption "Enable extensions";

    enableSync = mkEnableOption "Enable sync feature";
  };

  config = mkMerge [
    # Always enabled if module is enabled
    (mkIf cfg.enable {
      environment.systemPackages = [ pkgs.myapp ];
    })

    # Only if extensions enabled
    (mkIf (cfg.enable && cfg.enableExtensions) {
      environment.systemPackages = [ pkgs.myapp-extensions ];
    })

    # Only if sync enabled
    (mkIf (cfg.enable && cfg.enableSync) {
      services.myapp-sync.enable = true;
    })
  ];
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
  config = mkIf (gpuEnabled && gpuBrand == "nvidia") {
    # NVIDIA-specific configuration
  };
}
```

### Monitor Configuration

Monitors are configured in `config.monitors`:

```nix
let
  monitors = config.monitors;
in
{
  # Example: Generate monitor configs
  config.services.my-service.monitors = map (m: {
    name = m.name;
    width = m.width;
    height = m.height;
  }) monitors;
}
```

### Styling via Stylix

Stylix provides colors automatically. Access base16 colors if needed:

```nix
let
  inherit (config.lib.stylix.colors) base00 base01 base0A;
in
```

## Examples

### Example 1: Simple Application Module

```nix
# modules/applications/media/vlc.nix
{ lib, config, pkgs, ... }:

with lib;

{
  options.programs.media.vlc.enable = mkEnableOption "Enable VLC media player";

  config = mkIf config.programs.media.vlc.enable {
    environment.systemPackages = [ pkgs.vlc ];
  };
}
```

### Example 2: Complex Service Module

```nix
# modules/services/syncthing/default.nix
{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.servicesModule.syncthing;
  username = config.userOptions.username;
in
{
  options.servicesModule.syncthing = {
    enable = mkEnableOption "Enable Syncthing file sync";

    dataDir = mkOption {
      type = types.str;
      default = "/home/${username}/Sync";
      description = "Directory to sync";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Open firewall ports for Syncthing";
    };
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = username;
      dataDir = cfg.dataDir;
      openDefaultPorts = cfg.openFirewall;
    };
  };
}
```

### Example 3: Hardware Module with Multiple Options

```nix
# modules/hardware/webcam/default.nix
{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.hardwareModule.webcam;
in
{
  options.hardwareModule.webcam = {
    enable = mkEnableOption "Enable webcam support";

    brand = mkOption {
      type = types.enum [ "logitech" "generic" ];
      default = "generic";
      description = "Webcam brand for specific optimizations";
    };

    autoFocus = mkOption {
      type = types.bool;
      default = true;
      description = "Enable autofocus support";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      v4l-utils
      (mkIf (cfg.brand == "logitech") pkgs.logitech-camera-utils)
    ];

    boot.kernelModules = [ "v4l2loopback" ];
  };
}
```

## Best Practices

### 1. Use mkEnableOption

Always use `mkEnableOption` for the main enable option:

```nix
# Good
enable = mkEnableOption "Enable my feature";

# Avoid
enable = mkOption {
  type = types.bool;
  default = false;
  description = "Enable my feature";
};
```

### 2. Provide Sensible Defaults

```nix
package = mkOption {
  type = types.package;
  default = pkgs.myapp;  # Provide default
  description = "Package to use";
};
```

### 3. Document Options

```nix
optionalPackages = mkOption {
  type = types.listOf types.package;
  default = [ ];
  example = [ pkgs.extra-tool ];
  description = ''
    Additional packages to install alongside the defaults.
    These extend the functionality without replacing core packages.
  '';
};
```

### 4. Use Types Correctly

```nix
# Strings
type = types.str;

# Numbers
type = types.int;

# Booleans
type = types.bool;

# Packages
type = types.package;

# Lists of packages
type = types.listOf types.package;

# Enums (limited choices)
type = types.enum [ "option1" "option2" "option3" ];

# Nullable types
type = types.nullOr types.str;

# Attribute sets
type = types.attrs;
```

### 5. Avoid Imperative Commands

```nix
# Avoid
config = mkIf cfg.enable {
  system.activationScripts.setup = ''
    mkdir -p /some/path
    touch /some/file
  '';
};

# Prefer declarative
config = mkIf cfg.enable {
  systemd.tmpfiles.rules = [
    "d /some/path 0755 root root -"
    "f /some/file 0644 root root -"
  ];
};
```

### 6. One Feature Per Module

Don't combine unrelated features:

```nix
# Avoid
options.programs.miscTools = {
  enable = mkEnableOption "Enable misc tools";
  # browser, editor, terminal all in one?
};

# Prefer
options.programs.browser.enable = mkEnableOption "Enable browser";
options.programs.editor.enable = mkEnableOption "Enable editor";
options.programs.terminal.enable = mkEnableOption "Enable terminal";
```

### 7. Make Packages Configurable

Allow users to override packages:

```nix
package = mkOption {
  type = types.package;
  default = pkgs.firefox;
  description = "Firefox package to use";
};

config = mkIf cfg.enable {
  environment.systemPackages = [ cfg.package ];  # Use configurable package
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
   sudo nixos-rebuild build --flake .#Desktop
   ```

3. **Test Configuration:**
   ```bash
   sudo nixos-rebuild test --flake .#Desktop
   ```
   System will use new config but won't add to bootloader.

4. **Check if Feature Works:**
   ```bash
   # For programs
   which myapp
   myapp --version

   # For services
   systemctl status my-service
   ```

5. **Make Permanent:**
   ```bash
   sudo nixos-rebuild switch --flake .#Desktop
   ```

6. **Rollback if Needed:**
   ```bash
   sudo nixos-rebuild switch --rollback
   ```

### Testing Checklist

- [ ] Module builds successfully
- [ ] Packages are installed when enabled
- [ ] Services start correctly (if applicable)
- [ ] Configuration files are generated correctly
- [ ] Module works with both Desktop and Laptop hosts
- [ ] Disabling module removes everything cleanly
- [ ] No secrets or personal info in module
- [ ] Documentation is updated

## Troubleshooting

### Module Not Loading

**Check imports:**
```bash
nix-instantiate --eval -E '(import <nixpkgs/nixos> {}).config.programs.myFeature'
```

If "undefined", module isn't imported.

### Option Conflicts

**Error:** "The option `X` is defined multiple times"

**Fix:** Use `mkDefault` for defaults, `mkForce` to override:
```nix
programs.myapp.setting = mkDefault "default-value";
programs.myapp.setting = mkForce "override-value";
```

### Type Errors

**Error:** "value is a X while a Y was expected"

**Fix:** Check option type matches provided value:
```nix
# If option is types.str
programs.myapp.setting = "string";  # Good
programs.myapp.setting = 123;  # Bad

# If option is types.int
programs.myapp.count = 123;  # Good
programs.myapp.count = "123";  # Bad
```

## Further Reading

- [NixOS Module System Documentation](https://nixos.org/manual/nixos/stable/#sec-writing-modules)
- [Nixpkgs Manual - Module System](https://nixos.org/manual/nixpkgs/stable/#module-system)
- [Architecture Documentation](./ARCHITECTURE.md)
- [Contributing Guide](../CONTRIBUTING.md)
