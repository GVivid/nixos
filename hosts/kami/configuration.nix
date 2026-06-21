{
  config,
  inputs,
  unstable,
  pkgs,
  modulesDir,
  ...
}:

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
  environment.variables.EDITOR = "nvim";

  programs.pythonDev.enable = true;
  programs.dotnet.enable = true;

  programs.unstable.enable = true;
  programs.opencode.enable = true;
  programs.windowsVm.enable = true;
  system.stateVersion = "25.11";
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            # 'oneshot' ensures tap behavior, 'layer' handles the hold
            capslock = "layer(control_layer)";
          };
          control_layer = {
            # Tap once for escape
            # Hold to activate control
            capslock = "esc";
            "any" = "layer(control_layer)";
          };
        };
      };
    };
  };
}
