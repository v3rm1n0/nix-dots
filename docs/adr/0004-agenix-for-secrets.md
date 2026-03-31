# ADR 0004: Agenix for Secret Management

**Status:** Proposed (Not Yet Implemented)

**Date:** 2024

## Context

NixOS configurations are declarative and often stored in version control (git). However, some configuration requires secrets (API keys, passwords, certificates) that must never be committed to a repository. We need a secure, declarative way to manage secrets that integrates well with NixOS.

## Decision

We have chosen [agenix](https://github.com/ryantm/agenix) as the preferred secret management solution for when secrets are needed. It is not currently wired into the flake but is the recommended approach when secret management is required.

## Rationale

### What is Agenix?

Agenix encrypts secrets using SSH keys and provides a NixOS module to decrypt them at activation time. Secrets are:
- Encrypted with `age` (modern, simple encryption tool)
- Stored as `.age` files in the repository
- Decrypted only on authorized machines with the correct SSH key
- Never exposed in the Nix store (stored in `/run/agenix/` at runtime)

### Advantages

1. **Git-Friendly**
   - Encrypted secrets can be safely committed
   - Track secret changes over time

2. **SSH Key Integration**
   - Uses existing SSH keys for encryption
   - No new key infrastructure needed
   - Can use hardware security keys (YubiKey)

3. **Declarative**
   - Secrets declared in Nix configuration
   - File permissions and ownership set declaratively
   - Automatic decryption during system activation

4. **Per-Machine Secrets**
   - Different machines can have access to different secrets
   - Define in `secrets/secrets.nix` which keys can decrypt which secrets

5. **Runtime Security**
   - Secrets stored in `/run/agenix/` (tmpfs, RAM only)
   - Cleared on reboot
   - Restricted file permissions

## Alternatives Considered

### sops-nix
- **Pros:** Multiple encryption backends (age, GPG, cloud KMS)
- **Cons:** More complex, heavier dependencies
- **Rejected:** agenix simplicity preferred

### Environment Variables
- **Pros:** Simple, standard practice
- **Cons:** Not declarative, easy to leak in process lists
- **Rejected:** Not suitable for NixOS declarative model

### External Secret Stores (Vault, 1Password, etc.)
- **Pros:** Enterprise features, audit logs
- **Cons:** Extra infrastructure, network dependency, overkill for personal configs
- **Rejected:** Too complex for personal dotfiles

## Implementation (When Adopted)

### Add to flake.nix

```nix
inputs = {
  agenix = {
    url = "github:ryantm/agenix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  # ...
};
```

### Define Secrets

```nix
# secrets/secrets.nix
let
  host1 = "ssh-ed25519 AAAA... root@host1";
  host2 = "ssh-ed25519 AAAA... root@host2";
  user  = "ssh-ed25519 AAAA... user@machine";
in
{
  "some-secret.age".publicKeys = [ host1 user ];
  "shared-secret.age".publicKeys = [ host1 host2 user ];
}
```

### Create and Edit Secrets

```bash
cd secrets
agenix -e some-secret.age

# Rekey after adding/removing keys
agenix --rekey
```

### Reference in Configuration

```nix
age.secrets.some-secret = {
  file = ../secrets/some-secret.age;
  owner = config.userOptions.username;
  mode = "600";
};

# Use in services
services.my-service.passwordFile = config.age.secrets.some-secret.path;
```

## Security Considerations

**Protects Against:**
- Accidental git commits of plaintext secrets
- Unauthorized system access (without SSH key)
- Secret exposure in Nix store

**Does NOT Protect Against:**
- Root access on running system (secrets in `/run/agenix/`)
- SSH key compromise
- Physical access to unlocked machine

### Mitigations
- Use full disk encryption (LUKS) for defense in depth
- Keep SSH keys on encrypted partitions or hardware tokens
- Use strong SSH key passphrases

## Review

This decision should be reviewed if:
- Agenix project becomes unmaintained
- Security vulnerabilities discovered in age
- Need for more complex secret management (rotation, audit, multi-layer)

## References

- [Agenix GitHub](https://github.com/ryantm/agenix)
- [age Encryption Specification](https://age-encryption.org/)
- [NixOS Wiki - Agenix](https://nixos.wiki/wiki/Agenix)
