# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/). This repo contains configuration for tools I use daily on macOS and Windows.

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

## Manual setup (without chezmoi)

If you prefer to manage these dotfiles without chezmoi, you can clone and copy/symlink them manually.

### Prerequisites

- [git](https://git-scm.com/)
- Back up any existing configs first (e.g. `mv ~/.zshrc ~/.zshrc.bak`, `mv ~/.config/nvim ~/.config/nvim.bak`)

### Clone the repo

```bash
git clone https://github.com/auchiya/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### macOS / Linux

This repo uses chezmoi's `dot_` naming convention. Apply to `$HOME`:

```bash
# Create config dir if needed
mkdir -p ~/.config

# Shell
cp dot_zshrc ~/.zshrc
cp dot_zprofile ~/.zprofile

# Tools
cp -r dot_config/lazygit ~/.config/
cp -r dot_config/nvim ~/.config/
cp -r dot_config/ghostty ~/.config/
```

Optionally use symlinks so changes pull directly from the repo:

```bash
ln -s ~/dotfiles/dot_zshrc ~/.zshrc
ln -s ~/dotfiles/dot_zprofile ~/.zprofile
ln -s ~/dotfiles/dot_config/lazygit ~/.config/lazygit
ln -s ~/dotfiles/dot_config/nvim ~/.config/nvim
ln -s ~/dotfiles/dot_config/ghostty ~/.config/ghostty
```

### Windows

Paths differ by app. Common equivalents:

- Lazygit: `%APPDATA%\lazygit\` (copy `dot_config/lazygit/config.yml` there)
- Ghostty: copy `dot_config/ghostty/` to Ghostty's config directory (see Ghostty docs)
- Neovim: `%LOCALAPPDATA%\nvim\` or `%APPDATA%\nvim\` depending on setup (copy `dot_config/nvim/` contents accordingly)
- Zsh/profile are Unix-specific — skip on native Windows shells or use WSL

`.chezmoiignore` only affects chezmoi; manual setup means you decide what to copy/symlink.

### Updating (manual setup)

#### If using copies

```bash
cd ~/dotfiles
git pull
# Re-copy updated files (overwrites existing)
cp dot_zshrc ~/.zshrc
cp dot_zprofile ~/.zprofile
cp -r dot_config/lazygit ~/.config/
cp -r dot_config/nvim ~/.config/
cp -r dot_config/ghostty ~/.config/
```

#### If using symlinks

```bash
cd ~/dotfiles
git pull
# Symlinks stay pointing to updated files; no copy needed
```

Backup first if you made local changes not committed to this repo.

## Links

- [chezmoi documentation](https://www.chezmoi.io/docs/)
- [chezmoi quick start](https://www.chezmoi.io/quick-start/)
