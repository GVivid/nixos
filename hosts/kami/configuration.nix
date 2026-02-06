{ config,inputs,unstable,pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/global/default.nix
    ../../modules/hardware/nvidia.nix
    ../../modules/hardware/laptop.nix # (Your TLP/Power settings)
    ../../modules/unstable/unstable.nix
    ../../modules/users.nix
  ];

  #networking.hostName = "nixos";
  
  # Specific apps just for this machine
  environment.systemPackages = with pkgs; [
    firefox
    kitty
    unstable.hyprland
	# inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
	unstable.hyprcursor
	rofi
	dmenu
	nautilus
	swaybg
  ];

  system.stateVersion = "25.11";
}
