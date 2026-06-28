{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.syncthing;
in {
  options.custom.syncthing = {
    enable = mkEnableOption "Syncthing service";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
    };
  };
}
