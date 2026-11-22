# profile.ps1 or Microsoft.PowerShell_profile.ps1
#    powershell 7: ~/Document/PowerShell
#    older version: ~/Document/WindowsPowerShell

# Windows PowerShell 5 profile: reuse the PowerShell 7 config.
$sharedProfile = "$HOME\Documents\PowerShell\profile.ps1"
if (Test-Path -LiteralPath $sharedProfile)
{
  . $sharedProfile
}
