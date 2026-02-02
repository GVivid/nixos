{ pkgs, ... }:

{
services.syncthing = {
  enable = true;
  # openDefaultPorts = true;
  # Optional: GUI credentials (can be set in the browser instead)
};
}
