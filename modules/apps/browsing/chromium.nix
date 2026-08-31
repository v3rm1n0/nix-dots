_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      hostUsernames,
      userProfiles,
      ...
    }:
    let
      users = builtins.filter (
        n:
        builtins.elem "browsing-chromium" userProfiles.${n}.apps
        || builtins.elem "browsing-helium" userProfiles.${n}.apps
      ) hostUsernames;
    in
    {
      options.mods.apps.browsing.chromium.package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null;
        example = lib.literalExpression "pkgs.chromium";
        description = "The Chromium package to use.";
      };

      config = lib.mkMerge (
        [
          (lib.mkIf (users != [ ]) {
            programs.chromium = {
              enable = lib.mkDefault true;
              extraOpts = {
                "AudioSandboxEnabled" = false;
                "AutofillAddressEnabled" = false;
                "AutofillCreditCardEnabled" = false;
                "BlockThirdPartyCookies" = true;
                "BraveAIChatEnabled" = false;
                "BraveNewsDisabled" = true;
                "BraveRewardsDisabled" = true;
                "BraveStatsPingEnabled" = false;
                "BraveTalkDisabled" = true;
                "BraveVPNDisabled" = true;
                "BraveWalletDisabled" = true;
                "BraveP3AEnabled" = false;
                "BravePlaylistEnabled" = false;
                "DefaultSearchProviderEnabled" = true;
                "DefaultSearchProviderAlternateURLs" = [ "https://search.v3rm1n.dev/?q={searchTerms}" ];
                "DnsOverHttpsMode" = "secure";
                "DnsOverHttpsTemplates" = "https://dns.v3rm1n.dev/dns-query{?dns}";
                "RestoreOnStartup" = 4;
                "RestoreOnStartupURLs" = [ "https://start.v3rm1n.dev" ];
                "MetricsReportingEnabled" = false;
                "PasswordManagerEnabled" = false;
                "SafeBrowsingExtendedReportingEnabled" = false;
              };
              extensions = [
                "nngceckbapebfimnlniiiahkandclblb"
                "enamippconapkdmgfgjchkhakpfinmaj"
                "ldpochfccmkkmhdbclfhpagapcfdljkj"
                "mlomiejdfkolichcflejclcbmpeaniij"
                "bggfcpfjbdkhfhfmkjpbhnkhnpjjeomc"
                "gebbhagfogifgggkldgodflihgfeippi"
                "ponfpcnoihfmfllpaingbgckeeldkhle"
              ];
            };
          })
        ]
        ++ map (name: {
          hjem.users.${name}.packages = lib.optional (
            config.mods.apps.browsing.chromium.package != null
          ) config.mods.apps.browsing.chromium.package;
        }) users
      );
    };
}
