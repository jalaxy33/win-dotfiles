# MyTools.psm1
# Loads all function files from Private and Public, then exports only Public functions.

$moduleRoot = $PSScriptRoot

# Load order matters: Private first (helpers), then Public (commands that may use helpers).
foreach ($dir in @('Private', 'Public'))
{
  $path = Join-Path $moduleRoot $dir
  if (-not (Test-Path -LiteralPath $path))
  {
    continue
  }

  Get-ChildItem -LiteralPath $path -Filter '*.ps1' -File |
    Sort-Object Name |
    ForEach-Object { . $_.FullName }
}

# Export only functions defined in Public\*.ps1.
# Convention: one function per file, file name == function name.
$publicDir = Join-Path $moduleRoot 'Public'
$publicFunctions = @()
if (Test-Path -LiteralPath $publicDir)
{
  $publicFunctions = Get-ChildItem -LiteralPath $publicDir -Filter '*.ps1' -File |
    ForEach-Object { $_.BaseName }
}

if ($publicFunctions.Count -gt 0)
{
  Export-ModuleMember -Function $publicFunctions
}
