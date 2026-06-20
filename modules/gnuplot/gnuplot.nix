{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.gnuplotPkg;
in {
  options.programs.gnuplotPkg = {
    enable = mkEnableOption "Gnuplot package";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.gnuplot
    ];
  };
}
