{inputs, ...}: let
    lock-false = {
      Value = false;
      Status = "locked";
    };
    lock-true = {
      Value = true;
      Status = "locked";
    };
  in {
  home = {
    sessionVariables.BROWSER = "firefox";
  };

  programs.firefox = {
    enable = true;

    profiles.default = {
      name = "Default";
      settings = {
        "browser.tabs.loadInBackground" = true;
        "widget.gtk.rounded-bottom-corners.enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "gnomeTheme.hideSingleTab" = true;
        "gnomeTheme.bookmarksToolbarUnderTabs" = true;
        "gnomeTheme.normalWidthTabs" = false;
        "gnomeTheme.tabsAsHeaderbar" = false;
      };
    };

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
          "extensions.pocket.enabled" = locked-false;
          "browser.topsites.contile.enabled" = locked-false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = locked-false;
          "browser.newtabpage.activity-stream.feeds.snippets" = locked-false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = locked-false;
          "browser.newtabpage.activity-stream.showSponsored" = locked-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = locked-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = locked-false;
        };
      };
  };
}
