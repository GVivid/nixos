{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.latex;
in {
  options.custom.latex = {
    enable = mkEnableOption "LaTeX packages (tectonic, imagemagick, ghostscript)";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.tectonic
      pkgs.imagemagick
      pkgs.ghostscript
    ];
  };
}
