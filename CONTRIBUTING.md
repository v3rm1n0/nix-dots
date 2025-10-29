# Contributing to NixOS Dotfiles

Thank you for your interest in contributing! While this is primarily a personal configuration, improvements, bug fixes, and suggestions are welcome.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Guidelines](#code-guidelines)
- [Testing Changes](#testing-changes)
- [Submitting Contributions](#submitting-contributions)
- [Module Development](#module-development)

## Getting Started

### Prerequisites

- NixOS system (or Nix package manager on another Linux distro)
- Git
- Basic understanding of Nix language
- Flakes enabled in your Nix configuration

### Setting Up Development Environment

1. **Fork and clone the repository:**
   ```bash
   git clone https://github.com/v3rm1n0/nix-dots.git
   cd nix-dots
   ```

2. **Understand the structure:**
   Read [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) to understand the project layout and design principles.

3. **Check existing issues:**
   Browse [GitHub Issues](https://github.com/v3rm1n0/nix-dots/issues) for ways to help.

## Development Workflow

### Branch Strategy

1. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**

3. **Test thoroughly** (see [Testing Changes](#testing-changes))

4. **Commit with descriptive messages:**
   ```bash
   git commit -m "feat: add support for X"
   git commit -m "fix: resolve issue with Y"
   git commit -m "docs: update module documentation"
   ```

### Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks
- `style`: Code style changes (formatting)

**Examples:**
```
feat(gaming): add Steam Deck controller support

fix(hyprland): resolve multi-monitor scaling issue

docs(adr): add decision record for Btrfs choice

refactor(modules): consolidate browser configurations
```

## Code Guidelines

### Nix Code Style

1. **Use `nixfmt-tree` for formatting:**
   ```bash
   nix fmt
   ```

2. **Follow the module pattern:**
   ```nix
   { lib, config, pkgs, ... }:

   with lib;

   let
     cfg = config.programs.myFeature;
   in
   {
     options.programs.myFeature = {
       enable = mkEnableOption "Enable my feature";

       package = mkOption {
         type = types.package;
         default = pkgs.mypackage;
         description = "Package to use for my feature";
       };
     };

     config = mkIf cfg.enable {
       environment.systemPackages = [ cfg.package ];
     };
   }
   ```

3. **Use descriptive variable names:**
   ```nix
   # Good
   let
     defaultPackages = [ pkgs.firefox pkgs.chromium ];
   in

   # Avoid
   let
     pkgs = [ pkgs.firefox pkgs.chromium ];
   in
   ```

4. **Add descriptions to options:**
   ```nix
   optionalPackages = mkOption {
     type = types.listOf types.package;
     default = [ ];
     description = "Additional packages to install alongside defaults";
   };
   ```

5. **Keep modules focused:**
   - One feature per module
   - Don't mix unrelated functionality
   - Extract common code into shared utilities

### File Organization

1. **Module structure:**
   ```
   modules/category/feature/
   ├── default.nix        # Main module configuration
   ├── packages.nix       # Package definitions (if complex)
   └── home.nix           # Home Manager config (if separate)
   ```

2. **Keep files under 200 lines** when possible

3. **Use descriptive filenames**

4. **Group related imports:**
   ```nix
   {
     imports = [
       # Core modules
       ./applications
       ./desktop

       # Hardware support
       ./hardware

       # Services
       ./services
     ];
   }
   ```

### Documentation Standards

1. **Document all modules:**
   - Purpose and functionality
   - Configuration options
   - Usage examples
   - Dependencies

2. **Add inline comments for complex logic:**
   ```nix
   # Exclude specific packages from the default set when on laptop
   # to reduce closure size and improve battery life
   config = mkIf (cfg.enable && !isLaptop) {
     environment.systemPackages = defaultPackages;
   };
   ```

3. **Update README when adding features:**
   - Add to feature list
   - Update configuration examples
   - Add to troubleshooting if needed

## Testing Changes

### Local Testing

1. **Check flake syntax:**
   ```bash
   nix flake check
   ```

2. **Build without switching:**
   ```bash
   sudo nixos-rebuild build --flake .#Desktop
   ```

3. **Test configuration (temporary):**
   ```bash
   sudo nixos-rebuild test --flake .#Desktop
   ```
   This activates the configuration but doesn't add it to bootloader.

4. **Verify specific module:**
   ```bash
   # Check if option is recognized
   nixos-option programs.myFeature.enable

   # See what will be installed
   nix-instantiate --eval -E '(import <nixpkgs/nixos> {}).config.programs.myFeature.package'
   ```

5. **Switch and test thoroughly:**
   ```bash
   sudo nixos-rebuild switch --flake .#Desktop
   ```

### Testing Checklist

Before submitting:

- [ ] Code builds successfully (`nix flake check`)
- [ ] Configuration applies without errors
- [ ] Feature works as intended
- [ ] No regressions in existing functionality
- [ ] Documentation updated
- [ ] No secrets or personal info committed
- [ ] Formatted with `nix fmt`

### Rolling Back

If something breaks:
```bash
# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Or boot specific generation
sudo /nix/var/nix/profiles/system-N-link/bin/switch-to-configuration boot
```

## Submitting Contributions

### Pull Request Process

1. **Ensure all tests pass**

2. **Update documentation:**
   - README.md if adding user-facing features
   - docs/ARCHITECTURE.md if changing structure
   - Inline comments for complex code

3. **Create pull request:**
   - Clear title describing the change
   - Description explaining:
     - What changed
     - Why it changed
     - How to test it
   - Reference related issues

4. **PR Template:**
   ```markdown
   ## Description
   Brief description of changes

   ## Motivation
   Why is this change needed?

   ## Testing
   How was this tested?

   ## Screenshots (if applicable)
   Visual changes should include screenshots

   ## Checklist
   - [ ] Code builds (`nix flake check`)
   - [ ] Tested on NixOS
   - [ ] Documentation updated
   - [ ] No secrets committed
   ```

### Review Process

- Changes will be reviewed for:
  - Code quality and style
  - Adherence to architecture
  - Documentation completeness
  - Potential security issues
  - Breaking changes

- Be responsive to feedback
- Update PR based on review comments

## Module Development

### Creating a New Module

1. **Determine category:**
   - `applications/` - User applications
   - `desktop/` - Desktop environment components
   - `hardware/` - Hardware support
   - `security/` - Security features
   - `services/` - User services

2. **Create module file:**
   ```bash
   mkdir -p modules/applications/myapp
   touch modules/applications/myapp/default.nix
   ```

3. **Implement module:**
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

       settings = mkOption {
         type = types.attrs;
         default = { };
         description = "Configuration settings for MyApp";
       };
     };

     config = mkIf cfg.enable {
       environment.systemPackages = [ cfg.package ];

       # Home Manager integration
       home-manager.users.${config.userOptions.username} = {
         programs.myapp = {
           enable = true;
           settings = cfg.settings;
         };
       };
     };
   }
   ```

4. **Add import:**
   ```nix
   # modules/applications/default.nix
   {
     imports = [
       # ...
       ./myapp
     ];
   }
   ```

5. **Document in README:**
   Add to the feature list and configuration examples.

6. **Test:**
   Enable in a host config and verify functionality.

### Module Best Practices

1. **Provide sensible defaults:**
   ```nix
   optionalPackages = mkOption {
     type = types.listOf types.package;
     default = [ ];
     # ...
   };
   ```

2. **Make package configurable:**
   ```nix
   package = mkOption {
     type = types.package;
     default = pkgs.firefox;
     description = "Firefox package to use";
   };
   ```

3. **Use `mkDefault` for overridable defaults:**
   ```nix
   programs.myapp.someSetting = mkDefault "value";
   ```

4. **Validate inputs:**
   ```nix
   brand = mkOption {
     type = types.enum [ "nvidia" "amd" "intel" ];
     description = "GPU brand";
   };
   ```

5. **Handle optional features:**
   ```nix
   config = mkMerge [
     (mkIf cfg.enable {
       # Always enabled if feature is on
     })
     (mkIf (cfg.enable && cfg.extraFeature) {
       # Only if extra feature enabled
     })
   ];
   ```

## Reporting Issues

### Bug Reports

Include:
- NixOS version (`nixos-version`)
- Host configuration (Desktop/Laptop)
- Steps to reproduce
- Expected vs actual behavior
- Relevant logs (`journalctl -b`)

### Feature Requests

Include:
- Clear description of desired feature
- Use case / motivation
- Proposed implementation (optional)
- Willingness to contribute

## Questions and Discussion

- **GitHub Issues:** For bugs and feature requests
- **GitHub Discussions:** For questions and general discussion
- **README:** For documentation issues

## Recognition

Contributors will be:
- Credited in commit history
- Mentioned in release notes (if applicable)
- Listed in the README (for significant contributions)

## Code of Conduct

- Be respectful and constructive
- Focus on technical merit
- Welcome newcomers
- Assume good intentions
- Keep discussions on-topic

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

## Resources

### Learning Nix
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [nix.dev](https://nix.dev/)

### NixOS Modules
- [Module System Documentation](https://nixos.org/manual/nixos/stable/#sec-writing-modules)
- [Nixpkgs Manual](https://nixos.org/manual/nixpkgs/stable/)

### Project-Specific
- [Architecture Documentation](docs/ARCHITECTURE.md)
- [Architecture Decision Records](docs/adr/)

Thank you for contributing!
