function Add-Path
{
  <#
    .SYNOPSIS
    Adds one or more directories to the current process PATH.
    .DESCRIPTION
    Adds directories to $env:PATH for the current PowerShell process only.
    Duplicates are skipped (case-insensitive on Windows). Tilde and environment
    variables in paths are expanded before adding.
    .PARAMETER Path
    One or more directories to add.
    .PARAMETER Position
    Prepend (default) puts new entries at the front; Append puts them at the end.
    .PARAMETER MustExist
    Skip directories that do not exist on disk.
    .EXAMPLE
    Add-Path "$HOME\.local\bin", "$HOME\scoop\shims"
    .EXAMPLE
    Add-Path @("C:\tools\bin") -Position Append
    .EXAMPLE
    $paths | Add-Path -MustExist
    #>
  [CmdletBinding()]
  param(
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
    [string[]]$Path,

    [ValidateSet('Prepend', 'Append')]
    [string]$Position = 'Prepend',

    [switch]$MustExist
  )

  begin
  {
    $sep      = [IO.Path]::PathSeparator
    # $IsWindows is $false in Windows PowerShell 5.1, so test the OS directly.
    $comparer = if ($env:OS -eq 'Windows_NT')
    { [StringComparer]::OrdinalIgnoreCase
    } else
    { [StringComparer]::Ordinal
    }

    # Normalize current PATH into a list, preserving order and removing dupes.
    $entries = [System.Collections.Generic.List[string]]::new()
    $seen    = [System.Collections.Generic.HashSet[string]]::new($comparer)

    foreach ($p in ($env:PATH -split [regex]::Escape([string]$sep)))
    {
      if ([string]::IsNullOrWhiteSpace($p))
      {
        continue
      }
      $full = [IO.Path]::GetFullPath($p)
      if ($seen.Add($full))
      { $entries.Add($full)
      }
    }

    $newEntries = [System.Collections.Generic.List[string]]::new()
  }

  process
  {
    foreach ($raw in $Path)
    {
      if ([string]::IsNullOrWhiteSpace($raw))
      { continue
      }

      # Expand ~ and env vars, resolve to absolute path.
      $full = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($raw)

      if ($MustExist -and -not (Test-Path -LiteralPath $full -PathType Container))
      {
        Write-Warning "Skipping non-existent directory: $full"
        continue
      }

      # Skip if already present (keeps this idempotent).
      if (-not $seen.Add($full))
      {
        continue
      }

      $newEntries.Add($full)
    }
  }

  end
  {
    if ($newEntries.Count -eq 0)
    {
      return
    }

    if ($Position -eq 'Prepend')
    {
      $entries.InsertRange(0, $newEntries)
    } else
    {
      $entries.AddRange($newEntries)
    }

    $env:PATH = $entries -join $sep
  }
}
