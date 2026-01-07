{ config, pkgs, ... }:

{
  # LaTeX dependencies for emacs and neovim.
  home.packages = [
    pkgs.tectonic
    pkgs.imagemagick
    pkgs.ghostscript
  ];

}
