{ config, pkgs, ... }:

{
  # TODO: Separate user neovim config from user neovim config
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
  };
}
