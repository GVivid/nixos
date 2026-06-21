{ modulesDir, ... }:

{
  imports = [
    (modulesDir + "/hardware/nvidia.nix")
    (modulesDir + "/hardware/laptop.nix")
    (modulesDir + "/unstable/unstable.nix")
    (modulesDir + "/users.nix")
    (modulesDir + "/python-dev/python-dev.nix")
    (modulesDir + "/opencode/opencode.nix")
    (modulesDir + "/dotnet/dotnet.nix")
    (modulesDir + "/windows-vm/windows-vm.nix")
  ];
}
