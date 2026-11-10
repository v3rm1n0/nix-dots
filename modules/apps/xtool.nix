{ inputs, ... }:
{
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.mods.apps.xtool;
      pr = inputs.nixpkgs-xtool;
      xtoolOverlay = final: _prev: {
        open-apple-macros = final.callPackage "${pr}/pkgs/by-name/op/open-apple-macros/package.nix" { };
        xtool =
          (final.callPackage "${pr}/pkgs/by-name/xt/xtool/package.nix" { }).overrideAttrs
            (prev: {
              # xtool 1.24.0 password login traps (SIGILL) in Foundation's NSCalendar
              # bridge on Linux; upstream fix from xtool-org/xtool#422, unreleased.
              patches = (prev.patches or [ ]) ++ [ ./xtool-anisette-date-formatter.patch ];
            });
        xtoolBuildHook = final.callPackage "${pr}/pkgs/by-name/xt/xtoolBuildHook/package.nix" { };
      };

      # Same fix xtoolBuildHook applies for sandboxed builds, but for `xtool dev` in a shell.
      # nixpkgs' swift links upstream clang as bin/clang while libclang is the Swift fork;
      # Swift Build's explicit-module cc1 lines come from libclang and upstream clang rejects
      # them, and cc-wrapper adds Linux link flags ld64.lld rejects. Apple targets go to the
      # unwrapped fork clang instead; everything else keeps the wrapped one.
      swiftForXtool = pkgs.swift.override (prev: {
        llvmPackages_upstream = prev.llvmPackages_upstream // {
          clang = pkgs.runCommand "xtool-clang" { } ''
            mkdir -p $out/bin
            ln -s ${prev.llvmPackages_upstream.clang}/nix-support $out/nix-support
            for c in clang clang++; do
              substitute ${pr}/pkgs/by-name/xt/xtoolBuildHook/clang.sh $out/bin/$c \
                --subst-var-by shell ${pkgs.runtimeShell} \
                --subst-var-by apple ${prev.llvmPackages.clang-unwrapped}/bin/$c \
                --subst-var-by host ${prev.llvmPackages_upstream.clang}/bin/$c
              chmod +x $out/bin/$c
            done
          '';
        };
      });
    in
    {
      imports = [ "${pr}/nixos/modules/programs/xtool.nix" ];

      options.mods.apps.xtool = {
        enable = lib.mkEnableOption "xtool (cross-platform Xcode replacement) with usbmuxd and the Swift toolchain";

        sdk.enable = lib.mkEnableOption ''
          the Darwin SDK built from Xcode and linked into ~/.swiftpm. Needs
          Xcode added to the Nix store by hand first (see xtool's `sdk build`);
          without it, run `xtool sdk install` once instead
        '';
      };

      config = lib.mkIf cfg.enable {
        nixpkgs.overlays = [ xtoolOverlay ];

        programs.xtool = {
          enable = true;
          sdk.enable = cfg.sdk.enable;
        };

        environment.systemPackages = with pkgs; [
          swiftForXtool
          swiftpm
          libimobiledevice
        ];
      };
    };
}
