# profile.ps1 or Microsoft.PowerShell_profile.ps1
#    powershell 7: ~/Document/PowerShell
#    older version: ~/Document/WindowsPowerShell

# [Necessary!!!] install `scoop`
#   might be helpful: https://github.com/lzwme/scoop-proxy-cn

# Necessary apps:
#   7zip git
#   starship zoxide eza
#   fd ripgrep fzf
#   yazi ffmpeg jq poppler resvg imagemagick

# Optional but useful
#   neovim lazygit chezmoi

# Recommended Nerd Font:
#   `Maple-Mono-NF-CN` or `JetBrainsMono-NF-Mono`

# [Hint] create soft link by:
#    New-Item -ItemType SymbolicLink -Path "C:\Path\To\Link" -Target "C:\Path\To\Original"

Import-Module "$PSScriptRoot\Modules\MyTools"

#===============================
# Init apps
#===============================

# better prompt
if (Get-Command starship -EA 0)
{
  Invoke-Expression (&starship init powershell)
}

# smarter cd
if (Get-Command zoxide -EA 0)
{
  Invoke-Expression (& { (zoxide init powershell | Out-String) })
  Set-Alias cd z -Option AllScope
}


#===============================
# aliases
#===============================

# nvim
if (Get-Command nvim -EA 0)
{
  Set-Alias nv nvim -Option AllScope -Force
}

# vim
if (Get-Command vim -EA 0)
{
  Set-Alias vi vim -Option AllScope
}

# lazygit
if (Get-Command lazygit -EA 0)
{
  Set-Alias lg lazygit -Option AllScope
}

# prettier ls
if (Get-Command eza -EA 0)
{
  function els
  { eza --icons=auto -a -g @args
  }
  function ll
  { els -l @args
  }
  Set-Alias ls els -Option AllScope
}

# yazi
#
# yazi on windows require `file.exe` provided by git
#   Set `$env:YAZI_FILE_ONE` as `<Git_Installed_Directory>\usr\bin\file.exe`
function y
{
  $tmp = (New-TemporaryFile).FullName
  yazi.exe @args --cwd-file="$tmp"
  $cwd = Get-Content -Path $tmp -Encoding UTF8
  if ($cwd -and $cwd -ne $PWD.Path -and (Test-Path -LiteralPath $cwd -PathType Container))
  {
    Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
  }
  Remove-Item -Path $tmp
}


#===============================
# environment args
#===============================

# important env
#    $HOME == $env:USERPROFILE
#    `$env:APPDATA` and `$env:LOCALAPPDATA` alike `~/.config`
#
# Check all env by:
#    Get-ChildItem Env:

# this profile
$env:PROFILE = "$PSScriptRoot\profile.ps1"

# rust
$env:RUSTUP_DIST_SERVER = "https://mirrors.cernet.edu.cn/rustup"
$env:RUSTUP_UPDATE_ROOT = "https://mirrors.cernet.edu.cn/rustup/rustup"

# go
$env:GOPROXY = "https://mirrors.tencent.com/go/"

# yazi
$env:YAZI_CONFIG_HOME = "$HOME\.config\yazi"

# load $HOME/.env
Import-DotEnv


#===============================
# PATHS
#===============================

$pathsToAdd = @(
  # bun
  "$HOME\.bun\bin"
)
Add-Path -Path $pathsToAdd
