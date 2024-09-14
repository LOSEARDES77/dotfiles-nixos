{inputs, ...}: {
  home = {
    sessionVariables.BROWSER = "firefox";
  };

  programs.firefox = {
    enable = true;

    policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "always"; # alternatives: "always" or "newtab"
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"

        SearchEngines = {
          Default = "duckdukgo";
          PreventInstalls = true;
        };

        /* ---- EXTENSIONS ---- */
        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed".
        ExtensionSettings = {
          "*".installation_mode = "normal_installed"; # blocks all addons except the ones specified below
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          # Privacy Badger:
          "jid1-MnnxcxisBPnSXQ@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
            installation_mode = "force_installed";
          };
          # 1Password:
          "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
            installation_mode = "force_installed";
          };
          # Plasma browser
          "plasma-browser-integration@kde.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4298512/plasma_integration-1.9.1.xpi";
            installation_mode = "force_installed";
          };
        };

        Preferences = { 
          "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "duckdukgo";
          "extensions.pocket.enabled" = false;
          "browser.topsites.contile.enabled" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.system.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        };
      };
  };
}
