{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.opencode;
in {
  options.custom.opencode = {
    enable = mkEnableOption "OpenCode package";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.opencode ];
  };
}
