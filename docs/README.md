# Documentation Index

Welcome to the documentation for this NixOS configuration! This directory contains comprehensive guides and references to help you understand, use, and contribute to this project.

## 📚 Main Documentation

### For Users

**[Quick Reference Guide](QUICK_REFERENCE.md)** ⚡
- Common commands and operations
- Quick fixes for common issues
- Configuration shortcuts
- **Start here if you need to do something quickly**

**[Architecture Documentation](ARCHITECTURE.md)** 🏗️
- Project structure overview
- Module system explained
- Configuration flow
- Adding new features
- **Read this to understand how everything works**

### For Developers

**[Module Development Guide](MODULE_GUIDE.md)** 🔧
- Creating new modules
- Module patterns and examples
- Integration points
- Best practices and testing
- **Read this before creating or modifying modules**

**[Contributing Guide](../CONTRIBUTING.md)** 🤝
- Development workflow
- Code guidelines
- Pull request process
- Testing checklist
- **Read this before contributing**

## 🎯 Architecture Decision Records (ADRs)

ADRs document important architectural decisions and their rationale:

1. **[ADR-0001: Use Nix Flakes](adr/0001-use-nix-flakes.md)**
   - Why we chose Flakes over channels
   - Benefits and trade-offs

2. **[ADR-0002: Modular Architecture](adr/0002-modular-architecture.md)**
   - Module system design
   - Enable options pattern
   - Organization strategy

3. **[ADR-0003: Stylix for Theming](adr/0003-stylix-for-theming.md)**
   - Unified theming approach
   - Base16 color schemes
   - Application coverage

4. **[ADR-0004: Agenix for Secrets](adr/0004-agenix-for-secrets.md)**
   - Secret management strategy
   - Encryption with SSH keys
   - Security model

5. **[ADR-0005: Btrfs Filesystem](adr/0005-btrfs-filesystem.md)**
   - Filesystem choice rationale
   - Copy-on-write benefits
   - Maintenance strategy

## 🗂️ Additional Resources

### Project Files

- **[Main README](../README.md)** - Project overview, installation, features
- **[Secrets README](../secrets/readme.md)** - Agenix tutorial and examples
- **[Contributing](../CONTRIBUTING.md)** - Contribution guidelines

### Module Documentation

Many modules include inline documentation:
- `modules/user/default.nix` - User options system
- `modules/desktop/stylix/default.nix` - Theming configuration
- `modules/desktop/hypr/hyprland.nix` - Hyprland WM setup
- `system/nix/btrfs.nix` - Btrfs maintenance

## 🚀 Quick Start Paths

### "I want to use this configuration"

1. Read [Main README](../README.md) - Installation
2. Skim [Architecture Documentation](ARCHITECTURE.md) - Understand structure
3. Bookmark [Quick Reference](QUICK_REFERENCE.md) - Daily operations

### "I want to customize this configuration"

1. Read [Architecture Documentation](ARCHITECTURE.md) - Understand design
2. Read [Module Development Guide](MODULE_GUIDE.md) - Learn module system
3. Check [Quick Reference](QUICK_REFERENCE.md) - Common customizations

### "I want to contribute"

1. Read [Contributing Guide](../CONTRIBUTING.md) - Contribution process
2. Read [Module Development Guide](MODULE_GUIDE.md) - Module patterns
3. Read relevant [ADRs](#-architecture-decision-records-adrs) - Understand decisions

### "I have a problem"

1. Check [Quick Reference - Troubleshooting](QUICK_REFERENCE.md#troubleshooting)
2. Check [Architecture Documentation - Troubleshooting](ARCHITECTURE.md#troubleshooting)
3. Review [GitHub Issues](https://github.com/v3rm1n0/nix-dots/issues)

## 📖 Documentation Philosophy

This documentation follows these principles:

1. **Practical over Theoretical**
   - Real examples over abstract explanations
   - "How to do X" over "What is X"

2. **Progressive Disclosure**
   - Quick reference for common tasks
   - Deep dives available when needed
   - Links between related concepts

3. **Searchable and Browsable**
   - Clear table of contents
   - Descriptive headings
   - Cross-references

4. **Living Documentation**
   - Updated alongside code
   - Examples tested and verified
   - ADRs for major decisions

## 🔄 Keeping Documentation Updated

When making changes:

1. **Code Changes** → Update inline comments
2. **Module Changes** → Update [Module Guide](MODULE_GUIDE.md)
3. **User-Facing Changes** → Update [Main README](../README.md)
4. **Common Operations** → Update [Quick Reference](QUICK_REFERENCE.md)
5. **Major Decisions** → Create new ADR

## 🆘 Getting Help

If the documentation doesn't answer your question:

1. **Search existing documentation**
   ```bash
   grep -r "your question" docs/
   ```

2. **Check inline module documentation**
   ```bash
   cat modules/path/to/module/default.nix
   ```

3. **Review similar modules**
   - Look at existing modules in same category
   - Check their patterns and structure

4. **Ask for help**
   - Open a [GitHub Issue](https://github.com/v3rm1n0/nix-dots/issues)
   - Provide context and what you've tried

## 🎓 Learning NixOS

New to NixOS? These external resources complement this documentation:

### Official Documentation
- [NixOS Manual](https://nixos.org/manual/nixos/stable/) - Official reference
- [Nix Pills](https://nixos.org/guides/nix-pills/) - In-depth tutorial series
- [nix.dev](https://nix.dev/) - Community guides

### Specific Topics
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Stylix Documentation](https://stylix.danth.me/)

### Community
- [NixOS Discourse](https://discourse.nixos.org/)
- [NixOS Reddit](https://reddit.com/r/NixOS)
- [NixOS Wiki](https://nixos.wiki/)

## 📝 Documentation Structure

```
docs/
├── README.md                    # This file - documentation index
├── ARCHITECTURE.md              # System architecture and structure
├── MODULE_GUIDE.md              # Module development guide
├── QUICK_REFERENCE.md           # Quick reference for common tasks
└── adr/                         # Architecture Decision Records
    ├── 0001-use-nix-flakes.md
    ├── 0002-modular-architecture.md
    ├── 0003-stylix-for-theming.md
    ├── 0004-agenix-for-secrets.md
    └── 0005-btrfs-filesystem.md
```

## 🔍 Quick Search

Looking for something specific?

- **Changing theme** → [Quick Reference - Configuration Changes](QUICK_REFERENCE.md#configuration-changes)
- **Adding packages** → [Quick Reference - Adding Packages](QUICK_REFERENCE.md#adding-packages)
- **Creating modules** → [Module Guide - Creating New Module](MODULE_GUIDE.md#creating-a-new-module)
- **System updates** → [Quick Reference - Update Flake Inputs](QUICK_REFERENCE.md#update-flake-inputs)
- **Managing secrets** → [ADR-0004](adr/0004-agenix-for-secrets.md) or [Secrets README](../secrets/readme.md)
- **Keybindings** → [Hyprland module](../modules/desktop/hypr/hyprland.nix) (inline docs)
- **Troubleshooting** → [Quick Reference - Troubleshooting](QUICK_REFERENCE.md#troubleshooting)

## 💡 Tips

- Most modules have inline documentation - read them!
- The [Quick Reference](QUICK_REFERENCE.md) is your friend
- ADRs explain *why* decisions were made
- When in doubt, look at similar existing modules

---

**Happy configuring!** 🚀

If you find this documentation helpful, consider giving the project a star ⭐
