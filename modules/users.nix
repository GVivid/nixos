{ config, pkgs, inputs, ... }:

{
  users.users.kami = {
    isNormalUser = true;
    description = "kami";
    extraGroups = [ "networkmanager" "wheel"];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "kami" = import ./../home.nix;
    };
  };
}
