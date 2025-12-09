# Forensic Data Recovery Setup Plan for Proxmox Server

## Overview
This plan outlines a scalable forensic data recovery system using Proxmox VE on a server with dual Xeon E5-2650 v2 CPUs (16 cores/32 threads), 192GB RAM, 1Gbps network, and multiple HDD bays (up to 14TB drives). The goal is selective recovery of user data (e.g., home directories, logs, databases) from unknown drives, avoiding full OS imaging. The setup uses cloned VMs for isolation and efficiency, starting with one optimized VM that can be replicated for up to 5-6 bays.

## Key Assumptions and Goals
- **Hardware**: Server has MegaRAID SAS 2208 (for large hot-swap bays) and SATA AHCI controllers. 1Gbps to NAS limits transfers to ~125MB/s; image locally first.
- **Goals**: Recover user data intelligently, document OS/filesystems, copy to NAS. Handle 1-3 simultaneous recoveries (limited by IO/threads).
- **Approach**: Build one base VM, optimize for 1 drive, clone for multiples. Use passthrough for isolation; avoid VM backups.
- **Tools**: The Sleuth Kit (TSK), Autopsy, ddrescue, TestDisk/PhotoRec, blkid, disktype.
- **Risks**: Passthrough issues (e.g., ZFS corruption in backups), controller quirks—test thoroughly.

## Step-by-Step Implementation

### 1. Hardware and Software Preparation
- **Reinstall Proxmox**: Perform clean install of latest Proxmox VE (8.x+). Configure storage pools excluding recovery bays (use ZFS for host storage). Enable IOMMU in BIOS and Proxmox for passthrough.
- **Controller Setup**:
  - SATA AHCI (Intel C600/X79): Preferred for passthrough (simpler, reliable). Use for bays like sdf/sdg.
  - MegaRAID SAS 2208: For large bays (sda-sde). Set to HBA/IT mode in BIOS to disable RAID (avoids firmware issues). If passthrough fails, flash to IT mode.
- **Network**: Ensure 1Gbps eth0 is active for NAS transfers. Use vmbr0 bridge for VMs.
- **Drives**: Reserve bays for recovery (e.g., 1 for source, 1 for destination). Use passthrough for destination drive to ensure isolation.

### 2. Base VM Creation and Optimization
- **VM Specs**: Ubuntu 22.04 LTS, 8-16 cores, 64GB+ RAM, 20TB+ local storage (allocated from host ZFS pool).
- **Install Tools**:
  - `sudo apt update && sudo apt install -y autopsy sleuthkit ddrescue testdisk blkid util-linux`
  - Configure Autopsy for headless use; set TSK threads to 4.
- **Passthrough Setup**: Use SATA AHCI initially. Identify drive IDs with `ls /dev/disk/by-id/`. Add to VM: `qm set <VMID> -scsi0 /dev/disk/by-id/<drive>`.
- **Optimization**: Test with dummy drive. Ensure VM can detect filesystems (blkid), recover data (TSK/Autopsy), and write to local storage at 100-200MB/s.

### 3. Recovery Workflow Script
- **Script Purpose**: Automate detection, recovery, and transfer.
- **Key Steps**:
  - Detect drive: `blkid /dev/sdx` for filesystem; `disktype /dev/sdx` for OS hints.
  - Identify OS: Examine partitions (e.g., `fdisk -l /dev/sdx`), boot sectors for Windows/Linux signatures.
  - Selective Recovery: Use TSK (`fls /dev/sdx`) for directories; Autopsy for GUI analysis; ddrescue for damaged sectors.
  - Output: Write to VM local storage (e.g., /mnt/recovery/). Rsync to NAS: `rsync -av /mnt/recovery/ user@nas:/path/`.
- **Parallelism**: Run multiple instances (e.g., `ddrescue /dev/sda image1.img & ddrescue /dev/sdb image2.img &`).
- **Script Example** (Bash):
  ```
  #!/bin/bash
  DRIVE=$1
  OUTPUT_DIR="/mnt/recovery"
  NAS_PATH="user@nas:/recovery"

  # Detect
  FS=$(blkid $DRIVE | grep TYPE | cut -d'"' -f2)
  echo "Filesystem: $FS"

  # Recover (example: TSK for NTFS)
  if [ "$FS" == "ntfs" ]; then
    fls -r $DRIVE > $OUTPUT_DIR/filelist.txt
    icat $DRIVE <inode> > $OUTPUT_DIR/userdata  # Selective
  fi

  # Transfer
  rsync -av $OUTPUT_DIR $NAS_PATH
  ```

### 4. Cloning and Scalability
- **Clone Process**: After optimizing base VM (VMID 100), clone: `qm clone 100 101 --name recovery-101`. Increment VMID/bay ID for each clone.
- **Passthrough Adjustment**: For each clone, update passthrough: `qm set 101 -scsi0 /dev/disk/by-id/<new-drive>`.
- **Limits**: Run 1-2 VMs simultaneously (to avoid IO/thread contention). Max 5-6 clones based on bays/cores.

### 5. Testing and Validation
- **Test Drives**: Use healthy/damaged test drives. Measure speeds (aim 100-200MB/s), validate integrity (checksums).
- **Edge Cases**: Encrypted drives (use tools like dislocker), unknown formats (fallback to ddrescue).
- **Monitoring**: Use `iotop`, `htop` for performance; avoid VM backups.

### 6. Maintenance and Best Practices
- **Isolation**: Never backup VMs with passthrough (risks ZFS corruption).
- **Documentation**: Log recoveries (OS, data types, timestamps).
- **Security**: Run as non-root where possible; isolate VMs.
- **Updates**: Keep Proxmox/tools updated; re-test after changes.

## Potential Issues and Mitigations
- **Passthrough Failures**: MegaRAID quirks—use AHCI if possible. Debug with `dmesg | grep iommu`.
- **Performance**: If slow, check controller mode or add SSD caching.
- **Data Integrity**: Always verify recovered data; use write-blocker principles.
- **Scalability**: If 32 threads insufficient, limit to 1 VM per recovery.

## Timeline and Resources
- **Time**: 1-2 days for setup/testing.
- **Resources**: Free tools; Proxmox docs for passthrough.
- **Next Steps**: Implement base VM, test, clone.

This plan is modular—start small, scale as needed. Feedback welcome for refinements.