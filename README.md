# start

Automated onboarding for AXL Labs: Bootstraps a macOS development environment with essential CLI tools, productivity apps, and shell enhancements for efficient coding, Git/Docker workflows, and navigation.

## Overview

This repo provides a single `install.sh` bootstrap script that automates setup from a clean MacBook, installing Homebrew, packages, Oh My Zsh with plugins, shell configurations (zoxide, fnm), and aliases. It prioritizes fast, modern tools (e.g., GPU terminals, fuzzy finders). The script is idempotent—safe to re-run—and includes interactivity for terminal selection. Focus: Developer productivity without bloat.

## Prerequisites

- Fresh macOS install (Sonoma or later recommended; tested on Apple Silicon/Intel).
- Stable internet for downloads (Homebrew, Git clones, casks).
- Admin privileges (script prompts for password during Homebrew setup and app installs; ~5-10 prompts on first run).
- No prior developer tools assumed (e.g., no Homebrew or Xcode).

## Installation from bare MacOS

1. **Open Terminal** (built-in macOS Terminal.app suffices initially).

2. **Run the Installation Script**:
   - **Preferred (One-Liner Install – No Git or Clone Needed)**:
     ```
     # Using curl (built-in on macOS)
     curl -fsSL https://raw.githubusercontent.com/axl-labs/start/main/install.sh | bash

     # Using wget (install via Homebrew if needed, or use curl)
     wget -O- https://raw.githubusercontent.com/axl-labs/start/main/install.sh | bash
     ```
     - Downloads and executes the script directly. Installs everything, including terminal selection prompt. Enter your admin password when prompted (for Homebrew setup and app installs). No external files needed. Total: 5-15 min.
   - **Alternative (Full Repo Access – For Customizing Packages)**:
     ```
     git clone https://github.com/axl-labs/start.git ~/start
     cd ~/start
     chmod +x install.sh
     ./install.sh
     ```
     - Allows editing FORMULAS/CASKS arrays in install.sh or script before running.

## What Each Installed Program Does

>See this repo's `Brewfile` for a representation of what we recommend to install. You may always find more tools and apps to install on [brew.sh](https://brew.sh).

### CLI Tools (Homebrew Formulas – Command-Line Utilities)

Homebrew calls command-line packages "formulas". Find more at [brew.sh](https://brew.sh).

- Install a formula:
  ```
  brew install <formula>
  ```
- Upgrade formulas:
  ```
  brew update
  brew upgrade
  ```
- Uninstall a formula:
  ```
  brew uninstall <formula>
  ```
- Cleanup (optional):
  ```
  brew autoremove
  brew cleanup
  ```

These enhance terminal-based development, replacing/reinforcing built-ins for speed and usability.

- **bat**: Syntax-highlighted `cat` with line numbers, Git diff support. Replaces plain `cat` for reading code/logs.
- **fd**: Simple, fast file finder (better than `find`). Ignores .gitignore; usage: `fd pattern dir` for quick searches without regex hassle.
- **fnm**: Lightweight Node.js/Fast Node Manager. Installs/switches Node versions per project; shell hook auto-activates on `cd` (e.g., `fnm use` or auto).
- **fzf**: Interactive fuzzy matcher for files/history. Pipes into commands like `vim $(fzf)`; key bindings (Ctrl+R for history) make navigation intuitive.
- **hyperfine**: Simple benchmarking tool. Times commands: `hyperfine 'sleep 1' 'usleep 1000000'` to compare performance.
- **lazygit**: Git in TUI (text UI). Browse commits, stage files, rebase—all keyboard-driven; shortcut: `lg`.
- **lazydocker**: Docker management TUI. Monitor containers, view logs, exec commands; shortcut: `ldock`.
- **opencode**: Open-source AI coding tool (like Claude.dev). Integrates LLMs for code generation/refactoring; configure your model API key post-install.
- **ripgrep (rg)**: Blazing-fast line searcher (grep successor). Handles large codebases: `rg "TODO" src/`; respects .gitignore.
- **tree**: Prints directory trees. Visualizes project structure: `tree -L 2` (limits depth).
- **uv**: Ultra-fast Python tool (pip + venv alternative). Resolves dependencies quickly: `uv pip install pkg`; great for ML/data workflows.
- **zellij**: Modal terminal workspace (tmux alternative). Splits panes/tabs with mouse/keyboard; start with `zellij` for session management.
- **zoxide (z)**: Intelligent directory jumper. Tracks usage: `z proj` cds to frequent dirs; learns from `cd` history.

### GUI Applications (Homebrew Casks – Downloadable Apps)

Homebrew calls downloadable apps "casks". Find more at [brew.sh](https://brew.sh).

These provide visual interfaces for common dev tasks; installed into Applications.

- Install a cask:
  ```
  brew install --cask <app>
  ```
- Upgrade casks:
  ```
  brew update
  brew upgrade --cask --greedy
  ```
- Uninstall a cask:
  ```
  brew uninstall --cask <app>
  ```
- Uninstall and remove settings (optional):
  ```
  brew uninstall --cask --zap <app>
  ```

Some special ones include:

- **Terminal Emulator (User-Selected – One Installed)**:
  - **Alacritty**: GPU-accelerated, minimal terminal written in Rust. Config via YAML; blazing fast for heavy CLI use, no bloat.
  - **Ghostty**: GPU-acclerated terminal written in Zig. Ligature support, true color; optimized for speed and Apple ecosystem.
  - **Warp**: Modern terminal with blocks and AI-integration, written in Rust. Collaborative features, command suggestions; great for teams.
- **Rectangle**: Window manager. Keyboard shortcuts (e.g., Ctrl+Opt+Left) for snapping/resizing; boosts multitasking. Turns macOS into a pseudo-window manager.

### Shell and Plugin Enhancements

Customizes zsh/bash for better interactivity; applied to `~/.zshrc`/`.bashrc`.

- **Oh My Zsh**: Zsh config framework. Themes (default: robbyrussell), auto-updates; enables plugins without boilerplate.
- **zsh-autosuggestions**: Fish-like completions. Gray-suggests commands from history; accept with → arrow.
- **zsh-syntax-highlighting**: Real-time syntax checks. Colors valid/invalid commands green/red for quick feedback.

Shell Configurations (Appended):

- **zoxide Init**: Sets data dir (`~/.local/share/zoxide`) and replaces the `cd` command.
- **fnm Env**: Runs `fnm env --use-on-cd` to export PATH/NODE_VERSION, auto-switching Node on directory changes. All Node and Javascript environments should be handled by fnm.

### Aliases (in `~/.bash_aliases`, sourced by `bash` and `zsh`)

Reusable shortcuts to reduce typing; idempotent (added once).

- `lg`: Runs `lazygit` for instant Git UI.
- `ldock`: Runs `lazydocker` for Docker monitoring.
- `cat`: Overrides with `bat` for highlighted file viewing (e.g., `cat script.sh` shows syntax).
 