{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.gnuplot;
in {
  options.custom.gnuplot = {
    enable = mkEnableOption "Gnuplot package";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.gnuplot
    ];
  };
}
