# ADR 0004: Agenix for Secret Management

**Status:** Accepted

**Date:** 2024

## Context

NixOS configurations are declarative and often stored in version control (git). However, some configuration requires secrets (API keys, passwords, certificates) that must never be committed to a repository. We needed a secure, declarative way to manage secrets that integrates well with NixOS.

## Decision

We will use [agenix](https://github.com/ryantm/agenix) for secret management.

## Rationale

### What is Agenix?

Agenix encrypts secrets using SSH keys and provides a NixOS module to decrypt them at build/activation time. Secrets are:
- Encrypted with age (modern, simple encryption tool)
- Stored as `.age` files in the repository
- Decrypted only on authorized machines with the correct SSH key
- Never exposed in Nix store (stored in `/run/agenix/`)

### Advantages

1. **Git-Friendly**
   - Encrypted secrets can be safely committed
   - Track secret changes over time
   - No separate secret storage system needed

2. **SSH Key Integration**
   - Uses existing SSH keys for encryption
   - No new key infrastructure needed
   - Can use hardware security keys (YubiKey)

3. **Declarative**
   - Secrets declared in Nix configuration
   - File permissions and ownership set declaratively
   - Automatic decryption during system activation

4. **Simple Workflow**
   ```bash
   # Create/edit secret
   agenix -e secret.age

   # Secret is automatically decrypted on rebuild
   nixos-rebuild switch
   ```

5. **Per-Machine Secrets**
   - Different machines can have access to different secrets
   - Define in `secrets/secrets.nix` which keys can decrypt which secrets

6. **Runtime Security**
   - Secrets stored in `/run/agenix/` (tmpfs, RAM only)
   - Cleared on reboot
   - Restricted file permissions

### Security Model

```nix
# secrets/secrets.nix
let
  desktop = "ssh-ed25519 AAAA... root@desktop";
  laptop = "ssh-ed25519 AAAA... root@laptop";
  user = "ssh-ed25519 AAAA... user@machine";
in
{
  # Desktop-only secret
  "desktop-secret.age".publicKeys = [ desktop user ];

  # Laptop-only secret
  "laptop-secret.age".publicKeys = [ laptop user ];

  # Shared secret
  "shared-secret.age".publicKeys = [ desktop laptop user ];
}
```

## Alternatives Considered

### sops-nix
- **Pros:** Supports multiple encryption backends (age, GPG, cloud KMS), YAML/JSON secrets
- **Cons:** More complex, heavier dependencies, age is sufficient for our needs
- **Rejected:** Agenix simplicity preferred

### git-crypt
- **Pros:** Transparent encryption in git, well-established
- **Cons:** Uses GPG (complex), encrypts entire files (not NixOS-aware), less declarative
- **Rejected:** Not designed for NixOS

### Plain GPG Encryption
- **Pros:** Standard tool, no extra dependencies
- **Cons:** Manual decryption, key management complex, not integrated with NixOS
- **Rejected:** Too manual, error-prone

### External Secret Stores (Vault, 1Password, etc.)
- **Pros:** Enterprise features, audit logs, centralized management
- **Cons:** Extra infrastructure, network dependency, overkill for personal configs
- **Rejected:** Too complex for personal dotfiles

### Environment Variables
- **Pros:** Simple, standard practice
- **Cons:** Not declarative, hard to track, easy to leak in process lists, not persistent
- **Rejected:** Not suitable for NixOS declarative model

## Consequences

### Positive
- Secrets safely tracked in git
- Easy to backup and restore
- Simple mental model (SSH keys you already have)
- Automatic decryption during system build
- Clear permissions and ownership

### Negative
- Need to manage SSH keys carefully
- Losing SSH key means losing access to secrets (keep backups!)
- Need to re-encrypt if keys change
- Secrets in `/run/agenix/` are world-readable by root

### Neutral
- Additional tool to learn (`agenix` CLI)
- Secrets are encrypted with multiple keys (need to update all)

## Implementation

### Setup

1. **Generate SSH key for agenix:**
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/agenix_key
   ```

2. **Get system host key:**
   ```bash
   ssh-keyscan localhost 2>/dev/null | grep ed25519 | cut -d' ' -f2-
   ```

3. **Configure secrets access:**
   ```nix
   # secrets/secrets.nix
   let
     desktop = "ssh-ed25519 AAAA... root@Desktop";
     user = "ssh-ed25519 AAAA... user@machine";
     users = [ desktop user ];
   in
   {
     "wifi-password.age".publicKeys = users;
     "api-key.age".publicKeys = users;
   }
   ```

### Module Configuration

```nix
# modules/security/agenix/default.nix
{
  imports = [ agenix.nixosModules.default ];

  age.secrets.wifi-password = {
    file = ../../../secrets/wifi-password.age;
    owner = config.userOptions.username;
    group = "users";
    mode = "600";
  };
}
```

### Using Secrets

```nix
# Reference secret path in configuration
networking.wireless.environmentFile = config.age.secrets.wifi-password.path;

# Or in services
services.my-service = {
  enable = true;
  passwordFile = config.age.secrets.api-key.path;
};
```

### Editing Secrets

```bash
# Create new secret
cd secrets
agenix -e newsecret.age

# Edit existing secret
agenix -e wifi-password.age

# Rekey all secrets (after adding/removing keys)
agenix --rekey
```

## Best Practices

### Key Management
1. **Use dedicated SSH keys** for agenix (not your main SSH key)
2. **Backup SSH keys** securely (encrypted USB drive, password manager)
3. **Use different keys** for different security levels
4. **Consider hardware keys** (YubiKey) for high-security secrets

### Secret Organization
1. **One secret per file** for granular access control
2. **Descriptive names** (`tailscale-auth-key.age`, not `secret1.age`)
3. **Document secrets** in `secrets/readme.md`
4. **Minimize secret count** (use where necessary, not everywhere)

### Access Control
1. **Least privilege** - only decrypt on machines that need it
2. **User-specific secrets** - use user SSH keys for user-only secrets
3. **Separate system/user secrets** - different owner/permissions

### Rotation
1. **Regular rotation** - change secrets periodically
2. **After key compromise** - immediately rekey all secrets
3. **When removing host** - rekey to remove that host's access

## Security Considerations

### Threat Model

**Protects Against:**
- Accidental git commits of plaintext secrets
- Public repository exposure
- Unauthorized system access (without SSH key)
- Secret exposure in Nix store

**Does NOT Protect Against:**
- Root access on running system (secrets in `/run/agenix/`)
- SSH key compromise (attacker can decrypt)
- Memory dumps while secret is in use
- Physical access to unlocked machine

### Limitations

1. **Root Access**: Root user can read all secrets from `/run/agenix/`
2. **Build-Time Paths**: Secret *paths* are in Nix store, but not contents
3. **No Audit Log**: No built-in tracking of secret access
4. **Single-Layer Encryption**: No encryption at rest (relies on disk encryption)

### Mitigations

- Use full disk encryption (LUKS) for defense in depth
- Keep SSH keys on encrypted partitions or hardware tokens
- Use strong SSH key passphrases
- Regular security updates via `nix flake update`

## Migration

### From plaintext:
1. Create `.age` file for each secret
2. Encrypt with `agenix -e secret.age`
3. Reference in config: `config.age.secrets.secret.path`
4. Test, then delete plaintext

### From other secret managers:
1. Export secrets from current system
2. Import into agenix with `agenix -e`
3. Update configuration references
4. Verify access, then remove old system

## Review

This decision should be reviewed if:
- Agenix project becomes unmaintained
- Security vulnerabilities discovered in age
- Need for more complex secret management (rotation, audit, multi-layer)
- Scale increases (enterprise environment with many users)
- Hardware security requirements change (HSM, TPM integration)

## References

- [Agenix GitHub](https://github.com/ryantm/agenix)
- [age Encryption Specification](https://age-encryption.org/)
- [NixOS Wiki - Agenix](https://nixos.wiki/wiki/Agenix)
