function Clear-Pi
{
  <#
    .SYNOPSIS
    Removes the caches in the pi home directory, keeping configuration.
    .DESCRIPTION
    Deletes every top-level item in the pi home (default "$HOME\.pi") and in
    "$HOME\.pi\agent" that is not in the keep list. Sessions, logs, caches and
    any other generated data go away; config, extensions and extension JSON
    stay.

    Prompts for confirmation before each directory is emptied. Use -WhatIf to
    list what would be deleted, -Confirm:$false to delete without prompting.
    .PARAMETER PiHome
    The pi home directory. Defaults to "$HOME\.pi".
    .EXAMPLE
    Clear-Pi -WhatIf
    .EXAMPLE
    Clear-Pi -Confirm:$false
    .EXAMPLE
    Clear-Pi -PiHome "$HOME\.pi.bak"
  #>
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param(
    [string]$PiHome = (Join-Path $HOME '.pi')
  )

  $piHome = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($PiHome)
  if (-not (Test-Path -LiteralPath $piHome -PathType Container))
  {
    Write-Error "$piHome not found! Skipped."
    return
  }

  $piAgentDir = Join-Path $piHome 'agent'

  $piKeeps = @(
    # folders
    'agent'
    '.git'
    '.githooks'
    # files
    '.gitignore'
    'README.md'
    'LICENSE'
    # extension-related
    'web-search.json'
  )

  $piAgentKeeps = @(
    # folders
    'npm'
    'git'
    'extensions'
    'bin'
    'skills'
    # files
    '.gitignore'
    'auth.json'
    'settings.json'
    'models.json'
    'models.private.json'
    'keybindings.json'
    'models-store.json'
    'mcp.json'
    'APPEND_SYSTEM.md'
    'AGENTS.md'
    # extension-related
    'subagents.json'
    'multimodal-proxy.json'
    '.env'
  )

  foreach ($target in @(
      @{ Dir = $piHome; Keeps = $piKeeps }
      @{ Dir = $piAgentDir; Keeps = $piAgentKeeps }
    ))
  {
    $dir = $target.Dir

    if (-not (Test-Path -LiteralPath $dir -PathType Container))
    {
      Write-Warning "$dir not found! Skipped."
      continue
    }

    # -notin is case-insensitive, like Windows file names.
    $victims = @(Get-ChildItem -LiteralPath $dir -Force |
        Where-Object { $_.Name -notin $target.Keeps })

    Write-ColorLine ''
    Write-ColorLine "[Clear-Pi] $dir" -Color Cyan
    Write-ColorLine "  keep:   $($target.Keeps -join ' ')" -Color Green
    if ($victims.Count -eq 0)
    {
      Write-ColorLine '  remove: nothing' -Color DarkGray
      continue
    }
    Write-ColorLine "  remove: $($victims.Name -join ' ')" -Color Red

    if ($PSCmdlet.ShouldProcess($dir, "Delete $($victims.Count) item(s)"))
    {
      foreach ($item in $victims)
      {
        Remove-Item -LiteralPath $item.FullName -Recurse -Force -ErrorAction Stop
      }
      Write-ColorLine "  deleted $($victims.Count) item(s)." -Color Yellow
    }
  }
}
