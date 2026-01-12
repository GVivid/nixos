{ config, pkgs, inputs, ... }:

{
  imports = [
  ./../../modules/emacs/emacs.nix
  ./../../modules/neovim/neovim.nix
  ./../../modules/latex/latex.nix
  ./../../modules/gnuplot/gnuplot.nix
  ];
}
