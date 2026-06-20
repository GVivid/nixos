{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.opencode;
in {
  options.programs.opencode = {
    enable = mkEnableOption "OpenCode package";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.opencode ];
  };
}
