# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/). This repo contains configuration for tools I use daily on macOS (primary) and Windows (occasionally).

## What's included

- [Neovim (LazyVim)](https://lazyvim.github.io/) — editor configuration (`~/.config/nvim/`)
- [Lazygit](https://github.com/jesseduffield/lazygit) — git TUI (`~/.config/lazygit/config.yml`)
- [Ghostty](https://ghostty.org/) — terminal emulator config + custom shaders (`~/.config/ghostty/`)
- [Zsh](https://www.zsh.org/) — shell config (`~/.zshrc`, `~/.zprofile`)

## Prerequisites

- [chezmoi](https://www.chezmoi.io/install/) (v2.x)
- [git](https://git-scm.com/)
- macOS with [Homebrew](https://brew.sh/) or your package manager of choice

## Quick start

### Install on a new macOS machine

```bash
# Install chezmoi
brew install chezmoi

# Initialize and apply dotfiles in one go
chezmoi init --apply https://github.com/auchiya/dotfiles.git
```

### Install on a new Windows machine

```powershell
# Using Scoop
scoop install chezmoi

# Or using Chocolatey
choco install chezmoi

# Initialize and apply
chezmoi init --apply https://github.com/auchiya/dotfiles.git
```

## Usage

### Apply changes from repo to local machine
```bash
chezmoi apply
```

### Pull latest changes and apply
```bash
chezmoi update
```

### See what would change
```bash
chezmoi diff
```

### Verify configs match source
```bash
chezmoi verify
```

### Edit managed files
You can edit files in your home directory normally. After editing:
```bash
chezmoi diff          # see changes
chezmoi apply         # apply changes back to source if needed, or just keep
chezmoi add <file>    # track a newly modified/created file in source
```

Or edit the source directly in chezmoi's source directory:
```bash
chezmoi edit <file>
```

### Add a new file to be tracked
```bash
chezmoi add ~/.config/someapp/config.toml
```

### List all managed files
```bash
chezmoi managed
```

## Secrets & exclusions

Secrets are **not** tracked. The `.chezmoiignore` file prevents sensitive files (SSH keys, credentials, caches, etc.) from being added or applied. If you must track encrypted secrets, you can use chezmoi's encryption support (age/1Password/etc.), but the preference for this repo is to exclude secrets entirely.

## Structure

chezmoi stores files in its source directory (`~/.local/share/chezmoi/`) with `dot_` prefixes for dotfiles. For example:
- `dot_zshrc` → `~/.zshrc`
- `dot_config/nvim/` → `~/.config/nvim/`

## Links

- [chezmoi documentation](https://www.chezmoi.io/docs/)
- [chezmoi quick start](https://www.chezmoi.io/quick-start/)
