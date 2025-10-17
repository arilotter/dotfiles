{ pkgs, config, ... }:
{
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            bitwarden
            sponsorblock
            refined-github
            (buildFirefoxXpiAddon {
              pname = "phantom-app";
              version = "25.3.1";
              addonId = "{7c42eea1-b3e4-4be4-a56f-82a5852b12dc}";
              url = "https://addons.mozilla.org/firefox/downloads/file/4428642/phantom_app-25.3.1.xpi";
              sha256 = "sha256-zE2X6dkLiTiILu9w8Xx/9r9lmIuE9R7dk+KfcK3FjhY=";
              meta = {
                mozPermissions = [
                  "activeTab"
                  "alarms"
                  "identity"
                  "storage"
                  "scripting"
                  "tabs"
                  "webRequest"
                  "unlimitedStorage"
                  "http://*/*"
                  "https://*/*"
                ];
              };
            })
          ];
          force = true;
        };
        userChrome = ''
          #back-button, #forward-button {
            display: none;
          }
        '';
        settings = {
          "extensions.autoDisableScopes" = 0;
          "browser.tabs.animate" = false;
          "browser.ml.linkPreview.enabled" = false;
        };
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };
}
