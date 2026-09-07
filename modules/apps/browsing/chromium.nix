_: {
  flake.modules.nixos.default =
    { config, lib, ... }:
    {
      options.mods.apps.browsing.chromium = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Chromium browser.";
        };

        package = lib.mkOption {
          type = lib.types.nullOr lib.types.package;
          default = null;
          example = lib.literalExpression "pkgs.chromium";
          description = "The Chromium package to use.";
        };
      };

      config = lib.mkIf config.mods.apps.browsing.chromium.enable {
        environment.systemPackages = [
          config.mods.apps.browsing.chromium.package
        ];

        programs.chromium = {
          enable = lib.mkDefault true;
          extraOpts = {
            "AudioSandboxEnabled" = false;
            "AutofillAddressEnabled" = false;
            "AutofillCreditCardEnabled" = false;
            "BlockThirdPartyCookies" = true;
            "BraveAIChatEnabled" = false; # Disable Brave AI Chat
            "BraveNewsDisabled" = true; # Disable Brave News
            "BraveRewardsDisabled" = true; # Disable Brave Rewards
            "BraveStatsPingEnabled" = false;
            "BraveTalkDisabled" = true; # Disable Brave Talk
            "BraveVPNDisabled" = true; # Disable Brave VPN
            "BraveWalletDisabled" = true; # Disable Brave Wallet
            "BraveP3AEnabled" = false;
            "BravePlaylistEnabled" = false;
            "RestoreOnStartup" = 4; # Restore specified pages
            "MetricsReportingEnabled" = false;
            "PasswordManagerEnabled" = false;
            "SafeBrowsingExtendedReportingEnabled" = false;
            "SiteSearchSettings" = [
              {
                name = "nixpkgs packages";
                shortcut = "np";
                url = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
              }
              {
                name = "NixOS options";
                shortcut = "no";
                url = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
              }
              {
                name = "NixOS Wiki";
                shortcut = "nw";
                url = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
              }
            ];
          };
          extensions = [
            "ldpochfccmkkmhdbclfhpagapcfdljkj" # Decentraleyes
            "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # Privacy Badger
            "ghmbeldphafepmbegfdlkpapadhbakde" # Proton Pass
            #"cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
            "ponfpcnoihfmfllpaingbgckeeldkhle" # YouTube Enhancer
            "pjgickchbiikhdfpmecaabkphmofpdce" # Knock Off
          ];
        };
      };
    };
}
