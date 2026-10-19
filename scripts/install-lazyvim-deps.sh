#!/usr/bin/env bash
# Install core LazyVim dependencies (the tools checked by :checkhealth lazyvim).
# Idempotent: only installs what is missing. Manual script — chezmoi does not run it.
#
# Usage:
#   macOS / Linux / WSL:  bash "$(chezmoi source-path)/scripts/install-lazyvim-deps.sh"
set -euo pipefail

err() { printf 'error: %s\n' "$*" >&2; }

# --- Homebrew (required on both macOS and Linux) ---
if ! command -v brew >/dev/null 2>&1; then
  err "Homebrew is required but not installed."
  err "Install it first: https://brew.sh"
  exit 1
fi

# --- Xcode Command Line Tools (macOS only; treesitter parser builds need a C compiler) ---
if [ "$(uname -s)" = "Darwin" ] && ! xcode-select -p >/dev/null 2>&1; then
  err "Xcode Command Line Tools are not installed (required to build treesitter parsers)."
  err "Run: xcode-select --install"
  exit 1
fi

# command:brew-formula pairs (bash 3.2 compatible — macOS ships bash 3.2)
pairs="nvim:neovim git:git rg:ripgrep fd:fd fzf:fzf lazygit:lazygit tree-sitter:tree-sitter"

present=""
missing=""
for pair in $pairs; do
  cmd="${pair%%:*}"
  formula="${pair##*:}"
  if command -v "$cmd" >/dev/null 2>&1; then
    present="$present $cmd"
  else
    missing="$missing $formula"
  fi
done

# shellcheck disable=SC2086 # intentional word splitting
set -- $missing
if [ "$#" -gt 0 ]; then
  echo "Installing via Homebrew: $*"
  brew install "$@"
else
  echo "All dependencies already present, nothing to install."
fi

echo
echo "Summary:"
for pair in $pairs; do
  cmd="${pair%%:*}"
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '  %-12s OK (%s)\n' "$cmd" "$(command -v "$cmd")"
  else
    printf '  %-12s MISSING\n' "$cmd"
  fi
done

echo
echo "Nerd Font (required for icons — install manually):"
case "$(uname -s)" in
  Darwin)
    echo "  brew install --cask font-jetbrains-mono-nerd-font"
    ;;
  *)
    echo "  Download from https://www.nerdfonts.com/, extract the fonts into"
    echo "  ~/.local/share/fonts (or ~/.fonts), then run: fc-cache -f"
    ;;
esac
echo "Then restart nvim and check with: :checkhealth lazyvim"
