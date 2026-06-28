# Windows 11 VM — Usage Guide

## Overview

A NixOS module that sets up a KVM/libvirt Windows 11 VM for Visual Studio (.NET) development.

- **Enable flag**: `programs.windowsVm.enable = true;` (in `configuration.nix`)
- **Module file**: `modules/windows-vm/windows-vm.nix`

## What it does

- Enables `libvirtd` with KVM acceleration and SW TPM 2.0 (required by Windows 11)
- Adds user to `libvirtd` group
- Opens firewall for `virbr0` (libvirt NAT bridge)
- Creates `~/Virtual-Machines/windows-11/` directory
- Installs: `virt-manager`, `virt-viewer`, `spice-gtk`, `virtio-win`, `swtpm`, `xorriso`, `xmlstarlet`
- Creates two CLI commands (see below)

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | bool | — | Enable the Windows VM module |
| `vmDir` | str | `/home/kami/Virtual-Machines/windows-11` | VM directory (ISO, disk, drivers) |
| `vcpus` | int | 8 | vCPUs for the VM |
| `ram` | int | 8192 | RAM in MB |
| `diskSize` | str | `"80"` | Disk size in GB |
| `iothreads` | int | 2 | Dedicated I/O threads |
| `hugepages` | bool | false | Enable 2MB hugepages (requires contiguous RAM at boot) |

## Commands

### `windows-vm-create`

Creates and starts a new Windows 11 VM. Run once.

```
windows-vm-create
```

**During Windows install**, when the disk selection screen shows no drives:
1. Click **Load driver** → **Browse**
2. Navigate to the virtio-win CDROM drive
3. Select `viostor\w11\amd64` → **Next**
4. The disk will appear. Proceed with installation.

This sets up: virtio-blk disk (fast!), writeback cache, iothreads, UEFI, TPM 2.0, SPICE display, virtio NIC, virtio GPU, ICH9 sound, vCPUs and RAM from module config.

### `windows-vm`

Manages the running VM.

| Subcommand | Description |
|------------|-------------|
| `start` | Start VM + open SPICE viewer |
| `shutdown` | ACPI shutdown |
| `reboot` | ACPI reboot |
| `console` | Serial console |
| `edit` | Edit VM XML via `virsh edit` |
| `delete` | Destroy + undefine VM (irreversible!) |
| `tune` | Apply safe disk optimizations (writeback cache, io=threads) |
| `status` | Show VM state |

## For existing VMs (created before this module)

The module's `windows-vm-create` uses `virtio-blk` disk bus for best performance. If your VM was created on SATA (the old default):

1. Inside Windows, install the **viostor** driver from the virtio-win ISO via Device Manager
2. Shut down the VM
3. Edit the VM XML: change `<target dev='sda' bus='sata'/>` to `<target dev='vda' bus='virtio'/>`, remove the old `<address type='drive'>` element, and add `<iothreads>2</iothreads>` to `<domain>`
4. Run `windows-vm tune` for cache/I/O optimizations

## Troubleshooting

### No internet in VM
Windows lacks virtio NetKVM driver. In Device Manager, update the unrecognized "Ethernet Controller" driver from the virtio-win ISO (`NetKVM\w11\amd64`).

### "Display can only be attached through libvirt with --attach"
The `start` subcommand already uses `--attach`. If you see this error from other tools, add `-a` / `--attach` to `virt-viewer`.

### Disk on SATA even with new module
The `windows-vm-create` script uses `bus=virtio`. If you see SATA, the VM was created before the module update. Run `windows-vm tune` and manually migrate the disk bus following the "existing VMs" steps above.

### Hugepages allocation fails
Reduce `ram` or ensure enough contiguous memory is available at boot. Check with `cat /proc/meminfo | grep HugePages_*`.

### Not enough virtual cores
If you passed in 8 cores, but only 1 is being recognized, do windows-vm edit, and then modifiy cpu line with this.
```xml
  <cpu mode='host-passthrough' check='none' migratable='on'>
    <topology sockets='1' cores='4' threads='2'/>
  </cpu>
```

You can modify the topology until it makes sense for your system.
Read more here: https://woshub.com/vcpu-and-core-number-virtual-machine/

## Architecture

```
windows-vm-create
  ├── Builds virtio-win ISO from nixpkgs (xorriso)
  ├── Creates libvirt default NAT network if missing
  └── Runs virt-install with tuned parameters

windows-vm {start|shutdown|...}
  └── Wraps virsh commands with qemu:///system URI
      └── tune subcommand uses xmlstarlet to modify domain XML
```
