{ inputs,pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/global/default.nix
    ../../modules/hardware/nvidia.nix
    ../../modules/hardware/laptop.nix # (Your TLP/Power settings)
    ../../modules/users.nix
  ];

  #networking.hostName = "nixos";
  
  # Specific apps just for this machine
  environment.systemPackages = with pkgs; [
    firefox
    kitty
    hyprland
	rofi
	dmenu
	nautilus
	swaybg
  ];

  system.stateVersion = "25.11";
}
