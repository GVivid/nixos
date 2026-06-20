{ modulesDir, ... }:

{
  imports = [
    (modulesDir + "/emacs/emacs.nix")
    (modulesDir + "/neovim/neovim.nix")
    (modulesDir + "/latex/latex.nix")
    (modulesDir + "/gnuplot/gnuplot.nix")
    (modulesDir + "/syncthing/syncthing.nix")
    (modulesDir + "/firefox/firefox.nix")
  ];
}
