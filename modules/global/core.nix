{ pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  environment.systemPackages = with pkgs; [
    git
	gh
    vim
    neovim
    wget
    curl
    ripgrep
    zip
    unzip
	xclip
	wl-clipboard
	brightnessctl
  ];

  nixpkgs.config.allowUnfree = true;
}
