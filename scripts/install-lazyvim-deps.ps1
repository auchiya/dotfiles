# Install core LazyVim dependencies (the tools checked by :checkhealth lazyvim).
# Idempotent: installs only what is missing. Manual script — chezmoi does not run it.
#
# Usage (from PowerShell):
#   & "$(chezmoi source-path)\scripts\install-lazyvim-deps.ps1"
$ErrorActionPreference = "Stop"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Write-Host "error: winget is required but not installed." -ForegroundColor Red
  Write-Host "Install or update 'App Installer' from the Microsoft Store, then re-open this terminal."
  exit 1
}

$packages = @(
  @{ Cmd = "nvim";        Id = "Neovim.Neovim" }
  @{ Cmd = "git";         Id = "Git.Git" }
  @{ Cmd = "rg";          Id = "BurntSushi.ripgrep.MSVC" }
  @{ Cmd = "fd";          Id = "sharkdp.fd" }
  @{ Cmd = "fzf";         Id = "junegunn.fzf" }
  @{ Cmd = "lazygit";     Id = "jesseduffield.lazygit" }
  @{ Cmd = "tree-sitter"; Id = "Tree-sitter.Tree-sitter"; Fallback = "https://github.com/tree-sitter/tree-sitter/releases" }
)

$present = @()
$installed = @()
$failed = @()

foreach ($p in $packages) {
  if (Get-Command $p.Cmd -ErrorAction SilentlyContinue) {
    $present += $p.Cmd
    continue
  }

  Write-Host "Installing $($p.Id) ..."
  # Native commands: keep EAP Continue so winget's stderr can't throw mid-install
  $ErrorActionPreference = "Continue"
  winget install --id $p.Id -e --accept-package-agreements --accept-source-agreements | Out-Null
  $installCode = $LASTEXITCODE
  $ErrorActionPreference = "Stop"
  if ($installCode -eq 0) {
    $installed += $p.Cmd
    continue
  }

  # winget can return non-zero even when the package is already present
  # (e.g. stale PATH in this session). Confirm via winget list before reporting.
  $ErrorActionPreference = "Continue"
  winget list --id $p.Id -e 2>$null | Out-Null
  $listCode = $LASTEXITCODE
  $ErrorActionPreference = "Stop"
  if ($listCode -eq 0) {
    $present += $p.Cmd
    Write-Host "  $($p.Id): winget reported an issue but the package is installed (open a new terminal if '$($p.Cmd)' is still not found)."
  } else {
    $failed += "$($p.Id) (winget exit $installCode)"
    if ($p.Fallback) {
      Write-Host "  $($p.Id) not found in winget — install manually from: $($p.Fallback)"
    }
  }
}

Write-Host ""
Write-Host "Summary:"
if ($present.Count)     { Write-Host ("  already present: " + ($present -join ", ")) }
if ($installed.Count)   { Write-Host ("  newly installed: " + ($installed -join ", ")) }
if ($failed.Count)      {
  Write-Host ("  FAILED: " + ($failed -join ", ")) -ForegroundColor Red
  Write-Host "  Re-run this script in a NEW terminal to pick up fresh PATH values and retry."
}

Write-Host ""
Write-Host "Nerd Font (required for icons — install manually):"
Write-Host "  Download from https://www.nerdfonts.com/ and install the .ttf files"
Write-Host "  (double-click > Install, or copy to %LOCALAPPDATA%\Microsoft\Windows\Fonts)."
Write-Host ""
Write-Host "Note: if treesitter parser builds fail later (:checkhealth lazyvim), install a"
Write-Host "C compiler, e.g. winget install LLVM.LLVM"

if ($failed.Count) { exit 1 }
exit 0
