{ inputs, ... }:
{
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      hostUsernames,
      userProfiles,
      ...
    }:
    let
      users = builtins.filter (n: builtins.elem "browsing-helium" userProfiles.${n}.apps) hostUsernames;

      widevineUpdater = pkgs.writeShellApplication {
        name = "helium-widevine-update";
        runtimeInputs = with pkgs; [
          curl
          jq
          unzip
          coreutils
          findutils
        ];
        text = ''
          target_dir="$HOME/.config/net.imput.helium/WidevineCdm"

          widevine_json="$(curl -fsSL https://raw.githubusercontent.com/mozilla-firefox/firefox/refs/heads/main/toolkit/content/gmp-sources/widevinecdm.json)"

          hash_function="$(jq -r '.hashFunction' <<<"$widevine_json")"
          source_url="$(jq -r '.vendors["gmp-widevinecdm"].platforms["Linux_x86_64-gcc3"].mirrorUrls[0]' <<<"$widevine_json")"
          hash_value="$(jq -r '.vendors["gmp-widevinecdm"].platforms["Linux_x86_64-gcc3"].hashValue' <<<"$widevine_json")"

          [[ "$hash_function" == "sha512" ]] || { echo "unsupported hash function: $hash_function" >&2; exit 1; }
          [[ -n "$source_url" && "$source_url" != "null" ]] || { echo "failed to resolve widevine download url" >&2; exit 1; }

          tmp_dir="$(mktemp -d)"
          trap 'rm -rf "$tmp_dir"' EXIT

          crx_file="$tmp_dir/widevine.crx"
          curl -fL -o "$crx_file" "$source_url"
          echo "$hash_value  $crx_file" | sha512sum -c -

          unzip -q "$crx_file" -d "$tmp_dir" 2>/dev/null || true

          widevine_so="$tmp_dir/_platform_specific/linux_x64/libwidevinecdm.so"
          manifest="$tmp_dir/manifest.json"
          [[ -f "$widevine_so" && -f "$manifest" ]] || { echo "extracted widevine CDM is missing expected files" >&2; exit 1; }

          version="$(jq -r '.version' "$manifest")"
          version_dir="$target_dir/$version"

          if [[ -f "$version_dir/_platform_specific/linux_x64/libwidevinecdm.so" ]]; then
            echo "widevine CDM $version already installed"
            exit 0
          fi

          mkdir -p "$version_dir/_platform_specific/linux_x64"
          install -m755 "$widevine_so" "$version_dir/_platform_specific/linux_x64/libwidevinecdm.so"
          install -m644 "$manifest" "$version_dir/manifest.json"

          find "$target_dir" -mindepth 1 -maxdepth 1 -type d ! -name "$version" -exec rm -rf {} +

          echo "installed widevine CDM $version"
        '';
      };
    in
    {
      options.mods.apps.browsing.helium.package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;
        defaultText = lib.literalExpression "inputs.helium.packages.\${pkgs.stdenv.hostPlatform.system}.default";
        description = "The Helium package to use.";
      };

      config = lib.mkMerge (
        [
          (lib.mkIf (users != [ ]) {
            mods.apps.browsing.chromium.package = lib.mkDefault config.mods.apps.browsing.helium.package;
          })
        ]
        ++ map (name: {
          hjem.users.${name} = {
            packages = [ config.mods.apps.browsing.helium.package ];
            systemd = {
              services.helium-widevine-update = {
                description = "Fetch and install the Widevine CDM for Helium";
                after = [ "network-online.target" ];
                wants = [ "network-online.target" ];
                serviceConfig = {
                  Type = "oneshot";
                  ExecStart = lib.getExe widevineUpdater;
                };
              };

              timers.helium-widevine-update = {
                description = "Periodically refresh the Widevine CDM for Helium";
                wantedBy = [ "timers.target" ];
                timerConfig = {
                  OnBootSec = "5m";
                  OnUnitActiveSec = "7d";
                  Persistent = true;
                };
              };
            };
          };
        }) users
      );
    };
}
