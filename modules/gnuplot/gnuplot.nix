{ config, pkgs, ... }:

{
  # This lets me plot things on a graph. Useful for emacs.
  home.packages = [
    pkgs.gnuplot
  ];

}
