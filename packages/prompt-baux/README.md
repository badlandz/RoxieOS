# PROMPT-BAUX: Project Manifesto

## project still vaporware

## Introduction
PROMPT-BAUX is a meta-package designed to elevate the Bash shell prompt into a dynamic, extensible cornerstone of the RoxieOS ecosystem. As a lightweight Debian spinoff running sysvinit, RoxieOS prioritizes efficiency and minimalism for makers, developers, and tinkerers working with Arduino, Raspberry Pi, and similar embedded devices. With a focus on console-driven workflows—leveraging tools like neovim for coding, dwm and st for window management, and tmux for session handling—RoxieOS strips away unnecessary overhead to enable seamless transitions between writing code, flashing firmware to tiny devices, and monitoring real-time outputs. In this environment, where the graphical desktop is absent or minimal, the shell prompt isn't just a cursor—it's the primary interface for interaction, feedback, and data visualization.

PROMPT-BAUX bundles a customized, packaged version of Bash-it, a mature Bash framework, as its core dependency. This meta-package provides pre-configured themes, plugins, and extensions tailored for RoxieOS users, ensuring that the prompt becomes a "baux" (a playful nod to "box" or "auxiliary" tool) of productivity: beautiful, informative, and infinitely hackable. Whether you're polling sensor data from an AM2302 (DHT22) for temperature and humidity, graphing historical readings in ANSI art reminiscent of bashtop, or integrating outputs from Arduino sketches, Prompt-Baux transforms the prompt into a live dashboard that fits RoxieOS's ethos of "fun, efficient maker workflows."

## Why Prompt-Baux is Critical to RoxieOS
RoxieOS is engineered as a micro-Debian distro for resource-constrained hardware like older Raspberry Pi models (e.g., Model B) and Arduino setups, where every cycle counts. Traditional GUIs or heavy tools like Starship (Rust-based) introduce unacceptable lag and dependencies, bloating the system and disrupting the flow of coding, compiling, and deploying. In contrast, RoxieOS's console-centric design—built around neovim for editing, tmux for multiplexing sessions, and sysvinit for fast boots—demands a shell that's not only lightweight but also deeply integrated with development tasks.

Here's why Prompt-Baux is indispensable:

- **Resource Efficiency on Embedded Hardware**: RoxieOS targets low-end devices where prompt rendering must be sub-5ms to avoid typing lag. By packaging Bash-it in pure Bash (no external languages or binaries beyond core utilities), Prompt-Baux ensures negligible overhead—ideal for Pi Model B's 700MHz ARM. Unlike alternatives, it avoids direct sensor polling in the prompt (which could add seconds of delay) by favoring background logging and quick file tails, keeping the system responsive even during intensive tasks like firmware pushes.

- **Extensibility for Maker Workflows**: RoxieOS users often juggle sensors, GPIO, and serial outputs. Prompt-Baux's Bash-it foundation provides a plugin architecture that's perfect for scaling: start with simple segments for Git status or exit codes, then add custom plugins for AM2302 readings, Arduino debug logs, or even ANSI-graphing history data. This turns the prompt into a "key to functionality"—hitting Enter refreshes sensor stats without running commands, enabling "fun" visualizations like bashtop-style graphs for days of temperature history. In a distro focused on home automation hooks, this means developers can monitor prototypes in real-time without leaving their tmux/neovim session.

- **Seamless Integration with RoxieOS Tools**: The meta-package ships with configurations that play nicely with dwm's tiling, st's terminal simplicity, and tmux's multiplexing. For instance, plugins can hook into PROMPT_COMMAND for dynamic updates, ensuring data displays persist across splits. This tight integration reduces context-switching, critical for workflows like: edit in neovim, build/flash via Arduino CLI, and view outputs directly in the prompt—all without installing extra packages that could conflict with sysvinit's lean init system.

- **Community and Maintainability**: Bash-it's active community (14.8k+ GitHub stars) provides a robust base, but Prompt-Baux customizes it for RoxieOS by pre-enabling low-resource themes and including maker-specific examples (e.g., sensor extensions). As a meta-package, it simplifies installation (`apt install prompt-baux`) and upgrades, ensuring users get a "batteries-included" prompt without manual cloning or sourcing. This is vital for a distro like RoxieOS, where users might be beginners in Debian packaging but experts in hardware hacking—Prompt-Baux bridges that gap, making the OS more accessible and productive.

Without Prompt-Baux, RoxieOS's shell would remain a static relic, underutilizing the console's potential in a maker-focused distro. With it, the prompt evolves into an interactive hub: pretty for aesthetics, functional for data, and critical for turning raw hardware interactions into enjoyable, efficient development cycles. Whether prototyping home automation or debugging Pi sensors, Prompt-Baux ensures RoxieOS feels alive, responsive, and tailored for the next generation of tinkerers.

## Installation and Usage
Install via `sudo apt install prompt-baux` on RoxieOS. Source it in `~/.bashrc` with `source /usr/share/prompt-baux/bash-it.bash`, then enable features: `bash-it enable theme roxie-powerline; bash-it enable plugin sensor`. Customize plugins for your sensors, and watch your prompt become the heart of your workflow.

## Future Vision
Prompt-Baux will expand with more plugins for common Arduino/Pi peripherals, ANSI graphing utilities, and integrations with RoxieOS's firmware tools. Contributions welcome—let's make the console the ultimate maker playground!

```bash
# Define the segment function
function sensor_segment {
    local bg_color="${1}"
    local fg_color="${2}"
    local sensor_data=$(tail -1 ~/sensor.log 2>/dev/null | awk '{print $2 "°C " $3 "%"}')
    if [[ -n "$sensor_data" ]]; then
        local content=" $sensor_data"
        PS1+=$(segment_end "${fg_color}" "${bg_color}")
        PS1+=$(segment_content "${fg_color}" "${bg_color}" " ${content} ")
        __last_color="${bg_color}"
    fi
}

# Add to segments array (e.g., after path, before exit code)
pureline_segments+=('sensor_segment          236         255       ')  # Gray bg, white fg
```

```bash
prompt_callback() {
    local sensor_data=$(tail -1 ~/sensor.log 2>/dev/null | awk '{print $2 "°C " $3 "%"}')
    if [[ -n "$sensor_data" ]]; then
        echo -n " \[\e[38;5;45m\] ${sensor_data}\[\e[0m\]"  # Cyan color
    fi
}
```

```bash
# Sensor data function
_sensor_data() {
    tail -1 ~/sensor.log 2>/dev/null | awk '{print $2 "°C " $3 "%"}'
}

# Hook into PROMPT_COMMAND for refresh (optional, for dynamic updates)
_sensor_prompt_command() {
    local sensor=$(_sensor_data)
    if [[ -n "$sensor" ]]; then
        export SENSOR_INFO="\[\e[0;36m\] ${sensor}\[\e[0m\] "
    else
        export SENSOR_INFO=""
    fi
}
```
