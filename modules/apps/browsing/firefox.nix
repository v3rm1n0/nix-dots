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
      users = builtins.filter (n: builtins.elem "browsing-firefox" userProfiles.${n}.apps) hostUsernames;
    in
    {
      options.mods.apps.browsing.firefox.package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null;
        example = lib.literalExpression "pkgs.firefox";
        description = "The Firefox package to use.";
      };

      config =
        let
          cfg = config.mods.apps.browsing.firefox;
          isLibreWolf =
            cfg.package != null && lib.hasPrefix "librewolf" (cfg.package.pname or cfg.package.name or "");
        in
        lib.mkIf (users != [ ]) {
          programs = {
            firefox = {
              enable = lib.mkDefault true;
              inherit (cfg) package;
              preferencesStatus = lib.mkIf (!isLibreWolf) "locked";
              preferences = lib.mkIf (!isLibreWolf) {
                "browser.contentblocking.category" = "strict";
                "browser.formfill.enable" = false;
                "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
                "browser.newtabpage.activity-stream.feeds.snippets" = false;
                "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
                "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
                "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
                "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
                "browser.newtabpage.activity-stream.showSponsored" = false;
                "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
                "browser.newtabpage.activity-stream.system.showSponsored" = false;
                "browser.topsites.contile.enabled" = false;
                "extensions.pocket.enabled" = false;
              };
              policies = {
                DisableAccounts = false;
                DisableFirefoxAccounts = true;
                DisableFirefoxScreenshots = true;
                DisableFirefoxStudies = true;
                DisablePocket = true;
                DisableTelemetry = true;
                DisplayBookmarksToolbar = "never";
                DisplayMenuBar = "default-off";
                DontCheckDefaultBrowser = true;
                EnableTrackingProtection = {
                  Cryptomining = true;
                  Fingerprinting = true;
                  Locked = true;
                  Value = true;
                };
                OverrideFirstRunPage = "https://start.v3rm1n.dev";
                OverridePostUpdatePage = "";
                SearchBar = "unified";
                SearchEngines = {
                  Default = "DuckDuckGo";
                  Add = [
                    {
                      Name = "nixpkgs packages";
                      URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
                      IconURL = "https://wiki.nixos.org/favicon.ico";
                      Alias = "@np";
                    }
                    {
                      Name = "NixOS options";
                      URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
                      IconURL = "https://wiki.nixos.org/favicon.ico";
                      Alias = "@no";
                    }
                    {
                      Name = "NixOS Wiki";
                      URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
                      IconURL = "https://wiki.nixos.org/favicon.ico";
                      Alias = "@nw";
                    }
                  ];
                };

                ExtensionSettings =
                  let
                    moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
                  in
                  {
                    "*".installation_mode = "allowed";
                    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                      install_url = moz "bitwarden-password-manager";
                      installation_mode = "normal_installed";
                    };
                    "deArrow@ajay.app" = {
                      install_url = moz "dearrow";
                      installation_mode = "normal_installed";
                    };
                    "enhancerforyoutube@maximerf.addons.mozilla.org" = {
                      install_url = moz "enhancer-for-youtube";
                      installation_mode = "normal_installed";
                    };
                    "@enusplusdedebilingualdictionary" = {
                      install_url = moz "enus-dede-bilingual-dictionary";
                      installation_mode = "normal_installed";
                    };
                    "@contain-facebook" = {
                      install_url = moz "facebook-container";
                      installation_mode = "force_installed";
                    };
                    "@contain-google" = {
                      install_url = moz "google-container";
                      installation_mode = "force_installed";
                    };
                    "{eac6e624-97fa-4f28-9d24-c06c9b8aa713}" = {
                      install_url = moz "material-icons-for-github";
                      installation_mode = "normal_installed";
                    };
                    "@testpilot-containers" = {
                      install_url = moz "multi-account-containers";
                      installation_mode = "force_installed";
                    };
                    "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
                      install_url = moz "proton-pass";
                      installation_mode = "normal_installed";
                    };
                    "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
                      install_url = moz "return-youtube-dislikes";
                      installation_mode = "normal_installed";
                    };
                    "uBlock0@raymondhill.net" = {
                      install_url = moz "ublock-origin";
                      installation_mode = "force_installed";
                    };
                  };
              };
            };
          };
          environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";
        };
    };
}
