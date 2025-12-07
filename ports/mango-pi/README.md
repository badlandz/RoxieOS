# mango-pi - Mango Pi RISC-V Support for BAUXBSD

RISC-V expansion board support with ESP32 sensing integration.

## Overview

The Mango Pi is a RISC-V development board that serves as the foundation for BAUXBSD's embedded RISC-V deployments. Combined with ESP32 for advanced sensing capabilities, it enables fast recovery and environmental monitoring.

## Features

- **RISC-V Architecture**: Full FreeBSD/RISC-V support
- **ESP32 Integration**: Wireless sensing and communication
- **BAUX Compatibility**: Unified theming and session management
- **Fast Recovery**: Hardware-assisted system restoration

## Installation

```bash
cd /usr/ports/sysutils/mango-pi
make install clean
mango-setup
```

## Hardware Requirements

- Mango Pi RISC-V board
- ESP32 module for sensing
- Compatible power supply
- MicroSD card for storage

## Configuration

After installation, run `mango-setup` to configure GPIO and ESP32 tools.

## Integration

- **baux**: Session persistence across power cycles
- **ESP32 Sensing**: Environmental data collection
- **Fast Recovery**: Hardware watchdog for system stability

## Development

This port provides the foundation for RISC-V BAUXBSD development. Future updates will include:

- Device tree overlays
- ESP32 firmware
- Sensing protocols
- Recovery mechanisms