# ServerPair: FreeBSD + TrueNAS Dual-Server Setup for OCR/AI Workloads and Data Recovery

**Project Specification Document**  
**Version:** 3.0 (Expanded with Contingencies and Budget Scaling)  
**Date:** December 3, 2025  
**Author:** AI Assistant (Compiled from Research and Planning)  
**Purpose:** Complete guide for building a homelab dual-server setup optimized for OCR processing, AI pipelines, media serving, and forensic data recovery, using FreeBSD and TrueNAS.

## Executive Summary
This project outlines a high-performance, cost-effective dual-server homelab setup: a FreeBSD server with bhyve VMs for OCR/AI workloads and forensic data recovery, and a TrueNAS server for backups. Key optimizations include ZFS caching (ARC/L2ARC), slow-roll snapshots, bhyve passthrough for recovery, and hardware-specific tuning. Total cost: ~$200 for SSDs. Benefits: Purist FreeBSD learning, reliable data integrity, scalable AI/OCR pipelines, and integrated forensics. Risks: BIOS compatibility, MegaRAID passthrough quirks. Timeline: 2-3 days for rebuild and testing.

## Goals
- **Primary:** Build a FreeBSD-based system for OCR (ocrmypdf on 2TB/1TB datasets), AI (Ollama RAG), media (Plex/Jellyfin), and forensic data recovery in hot-swap bays, with PostgreSQL integration and Bash scripting.
- **Secondary:** Learn C, PostgreSQL, POSIX shell; create sensor data pipelines to AI for optimization.
- **Homelab Focus:** Reliable, expandable setup for daily use, with backups and monitoring.
- **Constraints:** $200 budget, existing hardware (dual Xeon servers), no GPU for AI.

## Hardware Specifications
### Proxmox Server (Now FreeBSD Server)
- **CPU:** Dual Intel Xeon E5-2650 v2 (16 cores/32 threads total, 2.60GHz base, supports VT-x for bhyve).
- **RAM:** 192GB DDR3 (12x16GB DIMMs).
- **Motherboard:** Supermicro X9DRW-7TPF (Intel C602 chipset, Socket 1366).
- **BIOS:** American Megatrends Inc. v3.0a (2014); update for FreeBSD compatibility.
- **Storage Controllers:** LSI MegaRAID SAS 2208 (8 ports, set to HBA mode), Intel SATA AHCI (8 ports).
- **Drives:** See Drive Mapping Table.
- **Network:** 10Gbps (82599ES), 1Gbps (I350), vmbr0 bridge for VMs.
- **Power/Cooling:** Redundant PSUs, 4x80mm fans; monitor temps for SSDs.
- **Compatibility Notes:** VT-x enabled; BIOS updates may fix kernel freezes.

### TrueNAS Server
- **CPU:** Intel Xeon E5520 (4 cores/8 threads, 2.27GHz, no VT-x—NAS only).
- **RAM:** Unknown (assume 32GB+ for ZFS).
- **Motherboard:** Unknown (older server board).
- **BIOS:** Unknown; ensure AHCI mode.
- **Storage Controllers:** SATA AHCI (for HDDs).
- **Drives:** 1TB SSD (boot), 5x4TB HDDs (RAIDZ1).
- **Network:** 1Gbps (assume).
- **Power/Cooling:** Standard server setup.
- **Compatibility Notes:** Debian-based TrueNAS optimized for ZFS; no VMs due to CPU limitations.

## Software Specifications
### FreeBSD 15 (Proxmox Server)
- **Hypervisor:** bhyve (loaded vmm module, vm-bhyve management).
- **File System:** ZFS (pools with compression, ARC/L2ARC caching).
- **VMs:** Ubuntu/Debian for OCR/AI tools (Tesseract, Ollama).
- **Tools:** PostgreSQL, Bash scripts, NeoVim for editing.
- **Networking:** Bridge for VM isolation.
- **Updates:** Quarterly; pkg for packages.

### TrueNAS (Debian-Based)
- **File System:** ZFS (RAIDZ1 pool, snapshots).
- **Purpose:** Backups only; ZFS send/receive from FreeBSD.
- **Tools:** Sanoid/Syncoid for snapshots.
- **Updates:** Stable releases.

## Implementation Plan
### Step 1: Hardware Prep
- Update BIOS on both servers (download from Supermicro/Intel sites).
- Set MegaRAID to HBA mode; enable AHCI.
- Install FreeBSD 15 on Proxmox server (ZFS root).
- Install/configure TrueNAS.

### Step 2: ZFS Pool Setup
- Proxmox: Mirror SSD pools for VMs, RAIDZ HDD for bulk.
- TrueNAS: RAIDZ1 HDD pool for backups.
- Enable compression, scrubbing.

### Step 3: VM Setup (bhyve)
- Install vm-bhyve: `pkg install vm-bhyve`.
- Create VMs: `vm create -t ubuntu -s 32G ocr1`.
- For forensic VM: Enable passthrough: `vm passthru -d /dev/daX forensic-vm`.
- Allocate resources per table.

### Step 4: Caching Optimization
- Tune ARC: `sysctl vfs.zfs.arc.max=64G`.
- Add L2ARC: `zpool add pool cache ssd-drive`.

### Drive Mapping Table
| Server | Interface | Drive | Capacity | Use | Why It Works |
|--------|-----------|-------|----------|-----|-------------|
| Proxmox (FreeBSD) | MegaRAID | Bay 1 | Adaptor + SSD | bhyve VM: OCR (2TB) | SSD speed for processing; bhyve isolation. |
| Proxmox (FreeBSD) | MegaRAID | Bay 2 | Adaptor + SSD | bhyve VM: OCR (1TB) | Parallel workloads; ZFS snapshots. |
| Proxmox (FreeBSD) | MegaRAID | Bay 3 | Adaptor + SSD | bhyve VM: AI (Ollama) | Dedicated resources; ARC caching. |
| Proxmox (FreeBSD) | MegaRAID | Bay 4 | Adaptor + SSD | bhyve VM: Forensic Recovery | Passthrough for unknown drives; bhyve for tools like Autopsy. |
| Proxmox (FreeBSD) | MegaRAID | Bay 5 | Adaptor + SSD | Emergency swap | Recovery; adaptor for cooling. |
| Proxmox (FreeBSD) | SATA AHCI | HDD | 4.5T | HDD pool: Media | Bulk storage; compression. |
| Proxmox (FreeBSD) | SATA AHCI | HDD | 5.5T | HDD pool: VMs | Redundancy. |
| Proxmox (FreeBSD) | SATA AHCI | SSD | 4TB | SSD pool: OCR/AI | High IOPS. |
| Proxmox (FreeBSD) | SATA AHCI | SSD | 2TB | SSD pool: Shared | Datasets for sharing. |
| Proxmox (FreeBSD) | SATA AHCI | SSD | 128GB | Boot/Root | Minimal. |
| TrueNAS | SATA AHCI | SSD | 128GB | Boot/Root | Simple. |
| TrueNAS | SATA AHCI | HDD | 4TB x5 | RAIDZ1: Backups | Snapshots for FreeBSD data. |

### VM/Resource Allocation Table
| VM/System | Cores/RAM | Storage | Purpose |
|-----------|-----------|---------|---------|
| OCR VM (2TB) | 8/32GB | SSD pool | Process PDFs to text. |
| OCR VM (1TB) | 8/32GB | SSD pool | Parallel processing. |
| AI VM | 8/32GB | SSD pool | Ollama RAG on text. |
| Forensic VM | 4/16GB | Passthrough bays | Data recovery with Autopsy/TK. |
| Workstations | 4/16GB each | SSD pool | User interfaces. |
| Plex/Jellyfin | 4/8GB each | HDD pool | Media servers. |
| Tiny Containers | 2/4GB total | SSD pool | Pihole, etc. |

## Backup/Snapshot Plan
- **NAS Snapshots:** Hourly (24h), daily (30d), weekly (1y) for Proxmox data.
- **Proxmox to NAS:** ZFS send/receive for repos.
- **Tools:** Sanoid for automation.

## Best Practices
- **ZFS:** Mirror VMs, RAIDZ bulk; scrub weekly.
- **bhyve:** Bridge networking; monitor with `vm list`.
- **Security:** Firewalls, encrypted pools.
- **Monitoring:** ZFS health, SMART, temps.
- **Power:** UPS; redundant PSUs.

## Conclusions
This setup achieves your goals: FreeBSD learning, OCR/AI efficiency, reliable backups, and integrated data recovery. Total cost: $200. Success depends on BIOS updates, MegaRAID HBA mode, and passthrough testing.

## Recommendations
- Start with BIOS updates.
- Test VMs incrementally.
- Monitor performance post-setup.

## Future Expansion Options ($50-100 Increments)
- **$50:** Add 500GB SSD for more caching or recovery tools (e.g., extra forensic VM storage).
- **$100:** Upgrade RAM or add HDD for storage; or build caseless recovery mini-PC (e.g., NUC with hot-swap bays) if bhyve passthrough fails.
- **Homelab Tips:** Label drives, document configs, join FreeBSD forums for support. Expect 2-3 days downtime for rebuild. For data recovery, test bhyve passthrough first—research shows it works for forensics but may need HBA mode on MegaRAID.

## Other Issues to Check
- **Hardware Compatibility:** BIOS updates (Supermicro X9DRW-7TPF: https://www.supermicro.com/support/resources/OS/C602_listing1.cfm); VT-x enabled; MegaRAID HBA mode (LSI docs: https://docs.broadcom.com/docs/LSISAS2208).
- **ZFS Health:** Scrub pools weekly (`zpool scrub pool`); monitor with `zpool status`.
- **Network Security:** Firewall VMs; use VLANs for isolation.
- **Performance Monitoring:** Install sysutils/htop; check temps with `sysctl dev.cpu.0.temperature`.
- **Backup Integrity:** Test restores quarterly; use offsite NAS replication.

## Scaled Budget and Contingency Plans
- **Base Budget ($200):** 2x 500GB SSDs for caching.
- **Scaled Additions ($200-500):**
  - $50: Backup UPS (APC BX1500M, https://www.apc.com/shop/us/en/products/APC-Back-UPS-BX1500M/P-BX1500M) for power protection.
  - $100: Extra 1TB SSD for VM storage; or redundant PSU (Supermicro PWR-920-SQ, https://www.supermicro.com/en/products/power-supplies).
  - $200: Caseless recovery mini-PC (Intel NUC 11, https://www.intel.com/content/www/us/en/products/sku/205049/intel-nuc-11-performance-kit-nuc11pahi50z/specifications.html) with hot-swap bays.
  - $500: Full rebuild with insurance (e.g., fire damage): Prioritize SSDs/SSDs, add ECC RAM (Crucial 64GB, https://www.crucial.com/memory/ddr4/ct16g4dfd8266).
- **Contingency Plans:**
  - **Hardware Failure:** Spare drives in bays; cloud backups (Backblaze, https://www.backblaze.com/).
  - **Data Loss:** ZFS snapshots; offsite NAS.
  - **Power Outage:** UPS; auto-shutdown scripts.
  - **Fire/Disaster:** Insurance claim for rebuild; document serials for claims.
  - **Scaling Issues:** If OCR/AI grows, add GPU (NVIDIA RTX 3060, https://www.nvidia.com/en-us/geeks-universe/rtx-3060/) for AI acceleration.

## References
- FreeBSD Handbook (docs.freebsd.org).
- ZFS Best Practices (klarasystems.com).
- bhyve Docs (wiki.freebsd.org/bhyve).
- Forensic Recovery with bhyve (forums.freebsd.org).
- BIOS Updates (supermicro.com/support).
- UPS Selection (apc.com).
- Intel NUC Specs (intel.com).