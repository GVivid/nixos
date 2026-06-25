{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.programs.firefoxCfg;
in {
  options.programs.firefoxCfg = {
    enable = mkEnableOption "Firefox profile configuration";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      policies."3rdparty".extensions."addon@darkreader.org" = {
        enabled = true;
        theme = {
          mode = 1;
          brightness = 100;
          contrast = 100;
          grayscale = 0;
          sepia = 0;
          useFont = false;
          fontFamily = "";
          textStroke = 0;
          engine = "dynamicTheme";
          stylesheet = "";
          darkSchemeBackgroundColor = "#1e1e2e";
          darkSchemeTextColor = "#cdd6f4";
          lightSchemeBackgroundColor = "#1e1e2e";
          lightSchemeTextColor = "#cdd6f4";
          scrollbarColor = "auto";
          selectionColor = "#45475a";
          styleSystemControls = true;
        };
      };

      profiles.kami = {
        search.engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
        };
        search.force = true;

        settings = {
          "dom.security.https_only_mode" = true;
          "browser.download.panel.shown" = true;
          "identity.fxaccounts.enabled" = false;
          "signon.rememberSignons" = false;
        };

        userChrome = ''
          /* some css */
        '';

        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          darkreader
        ];
      };
    };
  };
}
