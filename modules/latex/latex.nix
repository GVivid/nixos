{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.latexPkgs;
in {
  options.programs.latexPkgs = {
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
