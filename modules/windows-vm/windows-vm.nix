{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.windowsVm;
  user = "kami";
  vmDir = cfg.vmDir;
  vmName = "windows-11";
  vmDisk = "${vmDir}/win11.qcow2";
  winIso = "${vmDir}/Win11.iso";
  virtioIso = "${vmDir}/virtio-win.iso";
in {
  options.programs.windowsVm = {
    enable = mkEnableOption "a Windows 11 VM with libvirt/QEMU for Visual Studio development";

    vmDir = mkOption {
      type = types.str;
      default = "/home/${user}/Virtual-Machines/windows-11";
      defaultText = literalExpression "/home/${user}/Virtual-Machines/windows-11";
      description = "Directory containing the Windows 11 ISO and VM disk images.";
    };

    vcpus = mkOption {
      type = types.int;
      default = 8;
      description = "Number of CPU cores to allocate to the VM.";
    };

    ram = mkOption {
      type = types.int;
      default = 8192;
      description = "Amount of RAM (in MB) to allocate to the VM.";
    };

    diskSize = mkOption {
      type = types.str;
      default = "80";
      description = "Size of the VM disk in GB.";
    };

    iothreads = mkOption {
      type = types.int;
      default = 2;
      description = "Number of IO threads for disk operations.";
    };

    hugepages = mkEnableOption "2MB hugepages for the VM (reduces memory overhead, requires enough free contiguous memory)";
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };

    networking.firewall.trustedInterfaces = [ "virbr0" ];

    users.users.${user}.extraGroups = [ "libvirtd" ];

    boot.kernelParams = mkIf cfg.hugepages [
      "default_hugepagesz=2M"
      "hugepages=${toString (cfg.ram / 2)}"
    ];

    systemd.tmpfiles.rules = [
      "d ${vmDir} 0755 ${user} users -"
    ];

    environment.systemPackages =
      with pkgs;
      [
        virt-manager
        virt-viewer
        spice-gtk
        spice-vdagent
        virtio-win
        swtpm
        xorriso
        xmlstarlet
      ]
      ++ [
        (pkgs.writeShellScriptBin "windows-vm-create" ''
          set -euo pipefail
          export LIBVIRT_DEFAULT_URI="qemu:///system"

          if [ ! -f "${winIso}" ]; then
            echo "Error: Windows 11 ISO not found at ${winIso}"
            exit 1
          fi

          if [ ! -f "${virtioIso}" ]; then
            echo "Building virtio-win ISO from nixpkgs..."
            ${pkgs.xorriso}/bin/xorriso -as mkisofs \
              -o "${virtioIso}" \
              -J -R \
              ${pkgs.virtio-win}
          fi

          # Ensure the default network exists and is running
          if ! virsh net-info default >/dev/null 2>&1; then
            virsh net-define /dev/stdin <<'NETEOF'
        <network>
          <name>default</name>
          <forward mode='nat'/>
          <bridge name='virbr0' stp='on' delay='0'/>
          <ip address='192.168.122.1' netmask='255.255.255.0'>
            <dhcp>
              <range start='192.168.122.2' end='192.168.122.254'/>
            </dhcp>
          </ip>
        </network>
        NETEOF
          fi
          if ! virsh net-list --name --state-active | grep -qx default; then
            virsh net-start default
          fi

          exec virt-install \
            --name ${vmName} \
            --ram ${toString cfg.ram} \
            --vcpus ${toString cfg.vcpus} \
            --cpu host-passthrough \
            --os-variant win11 \
            --disk path=${vmDisk},size=${cfg.diskSize},format=qcow2,bus=virtio,cache=writeback,io=threads \
            --iothreads ${toString cfg.iothreads} \
            --cdrom "${winIso}" \
            --disk path="${virtioIso}",device=cdrom \
            --network network=default,model=virtio \
            --graphics spice,listen=none \
            --video virtio \
            --sound ich9 \
            --tpm backend.type=emulator,model=tpm-tis \
            --boot uefi \
            --check all=off
        '')
        (pkgs.writeShellScriptBin "windows-vm" ''
          set -euo pipefail
          export LIBVIRT_DEFAULT_URI="qemu:///system"
          case "''${1:-}" in
            start)
              virsh net-start default 2>/dev/null || true
              virsh start ${vmName}
              virt-viewer --wait --attach ${vmName} &
              ;;
            shutdown)
              virsh shutdown ${vmName}
              ;;
            reboot)
              virsh reboot ${vmName}
              ;;
            console)
              virsh console ${vmName}
              ;;
            edit)
              virsh edit ${vmName}
              ;;
            delete)
              virsh destroy ${vmName} 2>/dev/null || true
              virsh undefine ${vmName} --nvram
              ;;
            tune)
              if ! virsh dominfo ${vmName} >/dev/null 2>&1; then
                echo "Error: VM '${vmName}' does not exist."
                exit 1
              fi
              state=$(virsh domstate ${vmName})
              if [ "$state" = "running" ]; then
                echo "Shutting down VM..."
                virsh shutdown ${vmName}
                for _ in $(seq 30); do
                  [ "$(virsh domstate ${vmName})" != "running" ] && break
                  sleep 1
                done
                if [ "$(virsh domstate ${vmName})" = "running" ]; then
                  echo "Timed out waiting for shutdown, destroying..."
                  virsh destroy ${vmName}
                fi
              fi
              tmp=$(mktemp /tmp/windows-11.xml.XXXXXX)
              virsh dumpxml ${vmName} > "$tmp"
              changed=0
              cache=$(xmlstarlet sel -t -v "//disk[@device='disk']/driver/@cache" "$tmp" | head -1)
              if [ "$cache" != "writeback" ]; then
                xmlstarlet ed -L -u "//disk[@device='disk']/driver/@cache" -v "writeback" "$tmp"
                echo "Set disk cache to writeback"
                changed=1
              fi
              io=$(xmlstarlet sel -t -v "//disk[@device='disk']/driver/@io" "$tmp" | head -1)
              if [ "$io" != "threads" ]; then
                xmlstarlet ed -L -u "//disk[@device='disk']/driver/@io" -v "threads" "$tmp"
                echo "Set disk IO mode to threads"
                changed=1
              fi
              if [ "$changed" = "1" ]; then
                virsh define "$tmp"
                echo "VM tuned. Start with 'windows-vm start'."
              else
                echo "VM already tuned."
              fi
              rm -f "$tmp"
              ;;
            status)
              virsh domstate ${vmName}
              ;;
            *)
              echo "Usage: windows-vm {start|shutdown|reboot|console|edit|delete|tune|status}"
              exit 1
              ;;
          esac
        '')
      ];
  };
}
