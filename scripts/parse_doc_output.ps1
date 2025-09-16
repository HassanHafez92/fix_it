# Parse the documentation validator output and produce CSV of file,issue_count
$in = '.doc_validation_output.txt'
$out = '.doc_issues_counts.csv'
if (-not (Test-Path $in)) { Write-Error "Input file $in not found"; exit 1 }
$raw = Get-Content $in -Raw -Encoding UTF8
$lines = $raw -split "\r?\n"
$results = @()
for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    # Try to find a file path ending with .dart on the line
    $fileMatch = [regex]::Match($line, "([A-Za-z0-9_:\\\/\.-]+\.dart)")
    if ($fileMatch.Success) {
        $file = $fileMatch.Value
        $count = 0
        $j = $i + 1
        while ($j -lt $lines.Count -and $lines[$j].Trim() -ne '') {
            $l = $lines[$j]
            if ($l -match 'parameters not properly documented' -or $l -match 'missing "Business Rules"' -or $l -match 'return value not documented') {
                $count++
            }
            $j++
        }
        $results += "${file},${count}"
    }
}
Set-Content -Path $out -Value $results -Encoding UTF8
Write-Host "Wrote $out with $($results.Count) entries"