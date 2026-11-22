function Resolve-DotEnvValue
{
  param([string]$RawValue)

  $value = $RawValue.Trim()

  # Remove matching single or double quotes
  if ($value.Length -ge 2 -and
    (($value[0] -eq '"' -and $value[-1] -eq '"') -or
    ($value[0] -eq "'" -and $value[-1] -eq "'")))
  {
    return $value.Substring(1, $value.Length - 2)
  }

  # Remove inline comment after unquoted value
  return ($value -replace '\s+#.*$', '').Trim()
}
