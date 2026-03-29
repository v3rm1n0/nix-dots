{ self, inputs, ... }:
{
  flake.nixosModules.applicationsBrowsingChromium =
    { config, lib, ... }:
    {
      options.programs.browsing.chromium = {
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

      config = lib.mkIf config.programs.browsing.chromium.enable {
        environment.systemPackages = [
          config.programs.browsing.chromium.package
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
            "DefaultSearchProviderEnabled" = true;
            "DefaultSearchProviderAlternateURLs" = [ "https://search.v3rm1n.dev/?q={searchTerms}" ];
            "DnsOverHttpsMode" = "secure";
            "DnsOverHttpsTemplates" = "https://dns11.quad9.net/dns-query{?dns}";
            "RestoreOnStartup" = 4; # Restore specified pages
            "RestoreOnStartupURLs" = [ "https://start.v3rm1n.dev" ];
            "MetricsReportingEnabled" = false;
            "PasswordManagerEnabled" = false;
            "SafeBrowsingExtendedReportingEnabled" = false;
          };
          extensions = [
            #"nngceckbapebfimnlniiiahkandclblb" # Bitwarden
            "enamippconapkdmgfgjchkhakpfinmaj" # DeArrow
            "ldpochfccmkkmhdbclfhpagapcfdljkj" # Decentraleyes
            "mlomiejdfkolichcflejclcbmpeaniij" # Ghostery
            "bggfcpfjbdkhfhfmkjpbhnkhnpjjeomc" # Material Icons for GitHub
            #"pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # Privacy Badger
            "ghmbeldphafepmbegfdlkpapadhbakde" # Proton Pass
            "gebbhagfogifgggkldgodflihgfeippi" # Return YouTube Dislike
            #"cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
            "ponfpcnoihfmfllpaingbgckeeldkhle" # YouTube Enhancer
          ];
        };
      };
    };
}
