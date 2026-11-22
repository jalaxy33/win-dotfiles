<#
.SYNOPSIS
Loads environment variables from a .env file into the current PowerShell process.
.PARAMETER Path
Path to the .env file. Defaults to "$HOME/.env".
.EXAMPLE
Import-DotEnv -Verbose
#>
function Import-DotEnv {
    [CmdletBinding()]
    param(
        [string]$Path = (Join-Path $HOME '.env')
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Write-Warning "No .env file found: $Path"
        return
    }

    $loaded = 0
    $lineNo = 0

    foreach ($rawLine in Get-Content -LiteralPath $Path -Encoding UTF8) {
        $lineNo++
        $line = $rawLine.Trim()

        # Skip blank lines and full-line comments
        if ($line -eq '' -or $line.StartsWith('#')) { continue }

        # Support KEY=VALUE and export KEY=VALUE
        if ($line -match '^(?:export\s+)?([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)$') {
            $name  = $Matches[1]
            $value = Resolve-DotEnvValue -RawValue $Matches[2]

            [Environment]::SetEnvironmentVariable($name, $value, 'Process')
            $loaded++
        }
        else {
            Write-Warning "Skipped line $lineNo (invalid format): $rawLine"
        }
    }

    # Verbose-only diagnostic: reports source file and loaded variable count.
    Write-Verbose "Loaded $loaded variables from $Path into the current PowerShell process."
}
