{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.syncthingSvc;
in {
  options.programs.syncthingSvc = {
    enable = mkEnableOption "Syncthing service";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
    };
  };
}
