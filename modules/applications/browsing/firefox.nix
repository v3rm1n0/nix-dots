{
  config,
  lib,
  ...
}:
{
  options.programs.browsing.firefox = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Firefox browser.";
    };

    package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = null;
      example = lib.literalExpression "pkgs.firefox";
      description = "The Firefox package to use.";
    };
  };

  config = lib.mkIf config.programs.browsing.firefox.enable {
    programs = {
      firefox = {
        enable = lib.mkDefault true;
        package = config.programs.browsing.firefox.package;
        languagePacks = [
          "de"
          "en-US"
        ];

        # ─── About:config prefs ───────────────────────────────────────────────────────
        preferencesStatus = "locked";
        preferences = {
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
          # Broken due to "stability issues"
          /*
            "privacy.donottrackheader.enabled" = true;
            "privacy.fingerprintingProtection" = true;
            "privacy.resistFingerprinting" = true;
            "privacy.trackingprotection.emailtracking.enabled" = true;
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.fingerprinting.enabled" = true;
            "privacy.trackingprotection.socialtracking.enabled" = true;
          */
        };
        # ─── Enterprise policies (non‑pref things) ────────────────────────────────────
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

          # ─── Extensions ───────────────────────────────────────────────────────────────
          ExtensionSettings = {
            "*".installation_mode = "allowed";
            "adnauseam@rednoise.org" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/adnauseam/latest.xpi";
              installation_mode = "force_installed";
            };
            "addon@darkreader.org" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
              installation_mode = "normal_installed";
            };
            # Bitwarden:
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
              installation_mode = "force_installed";
            };
            # DeArrow:
            "deArrow@ajay.app" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/dearrow/latest.xpi";
              installation_mode = "normal_installed";
            };
            # Facebook Container
            "@contain-facebook" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/facebook-container/latest.xpi";
              installation_mode = "force_installed";
            };
            # Google containers (not official)
            "@contain-google" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/google-container/latest.xpi";
              installation_mode = "force_installed";
            };
            # Meterial Icons for GitHub:
            "{eac6e624-97fa-4f28-9d24-c06c9b8aa713}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/material-icons-for-github/latest.xpi";
              installation_mode = "normal_installed";
            };
            # Multi Account Containers
            "@testpilot-containers" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
              installation_mode = "force_installed";
            };
            # Privacy Badger:
            #"jid1-MnnxcxisBPnSXQ@jetpack" = {
            #  install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
            #  installation_mode = "force_installed";
            #};
            # Qwant Search:
            "qwant-search-firefox@qwant.com" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/qwant-the-search-engine/latest.xpi";
              installation_mode = "normal_installed";
            };
            # Return YouTube Dislike:
            "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi";
              installation_mode = "normal_installed";
            };
            # uBlock Origin:
            #"uBlock0@raymondhill.net" = {
            #  install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            #  installation_mode = "force_installed";
            #};
            # YouTube High Definition:
            "{7b1bf0b6-a1b9-42b0-b75d-252036438bdc}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-high-definition/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        };
      };
    };
    environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";
  };
}
