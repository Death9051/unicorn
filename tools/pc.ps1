# Sends JSON-lines requests to a running PhotoCraft (started by photocraft-ui.cmd).
# Usage: pc.ps1 '<method>' '<params json>' [ '<method>' '<params json>' ... ]
param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Calls)
$ErrorActionPreference = 'Stop'
$tok = (Get-Content "$env:USERPROFILE\.photocraft\control.token" -Raw).Trim()
$c = New-Object System.Net.Sockets.TcpClient('127.0.0.1', 47821)
$s = $c.GetStream(); $s.ReadTimeout = 120000
$enc = New-Object System.Text.UTF8Encoding($false)
$w = New-Object System.IO.StreamWriter($s, $enc); $w.AutoFlush = $true
$r = New-Object System.IO.StreamReader($s, $enc)
$w.WriteLine((@{ id = 0; method = 'auth'; params = @{ token = $tok } } | ConvertTo-Json -Compress))
$null = $r.ReadLine()
for ($i = 0; $i -lt $Calls.Count; $i += 2) {
  $p = if ($i + 1 -lt $Calls.Count -and $Calls[$i + 1]) { $Calls[$i + 1] } else { '{}' }
  $w.WriteLine('{"id":' + ($i / 2 + 1) + ',"method":"' + $Calls[$i] + '","params":' + $p + '}')
  $r.ReadLine()
}
$c.Close()
