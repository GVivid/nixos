{ config, inputs, unstable, pkgs, modulesDir, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (modulesDir + "/global/default.nix")
    (modulesDir + "/system/default.nix")
  ];

  #networking.hostName = "nixos";
  
  # Specific apps just for this machine
  environment.systemPackages = with pkgs; [
    # firefox
    kitty
    unstable.hyprland
	# inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
	unstable.hyprcursor
	rofi
	dmenu
	nautilus
	swaybg
  ];

  programs.pythonDev.enable = true;
  programs.unstable.enable = true;
  programs.opencode.enable = true;
  system.stateVersion = "25.11";
  services.keyd = {
  enable = true;
  keyboards = {
    default = {
      ids = ["*"];
      settings = {
        main = {
          capslock = "overload(control, esc)";
        };
      };
    };
  };
};
}
