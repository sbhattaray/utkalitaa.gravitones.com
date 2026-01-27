# PowerShell script to update PDF metadata title
# Updates the /Title field in PDF metadata

$PdfPath = Join-Path $PSScriptRoot "Admission.pdf"
$OutputPath = Join-Path $PSScriptRoot "Admission_updated.pdf"
$NewTitle = "Day Care Admission Form"

Write-Host ""
Write-Host "PDF Title Updater" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan
Write-Host ""

# Check if file exists
if (-not (Test-Path $PdfPath)) {
    Write-Host "Error: PDF file not found at $PdfPath" -ForegroundColor Red
    exit 1
}

Write-Host "Reading PDF file: $PdfPath" -ForegroundColor Yellow

try {
    # Read PDF as bytes
    $bytes = [System.IO.File]::ReadAllBytes($PdfPath)
    Write-Host "File size: $($bytes.Length) bytes" -ForegroundColor Gray
    
    # Convert to string (using Latin1 to preserve binary data)
    $content = [System.Text.Encoding]::GetEncoding("ISO-8859-1").GetString($bytes)
    
    # Find and display the old title - match title including escaped parentheses and line breaks
    # PDF format: /Title (text with \( and \) inside)
    # The pattern needs to match everything between the opening ( and closing ) accounting for escaped parens
    $titlePattern = '/Title\s*\((?:[^()]|\\[()])*\)'
    $titleMatches = [regex]::Matches($content, $titlePattern, [Text.RegularExpressions.RegexOptions]::Singleline)
    if ($titleMatches.Count -gt 0) {
        Write-Host ""
        Write-Host "Found title metadata:" -ForegroundColor Green
        $fullMatch = $titleMatches[0].Value
        # Extract just the title text (between parentheses)
        if ($fullMatch -match '/Title\s*\((.*)\)') {
            $oldTitle = $matches[1]
            # Show truncated version if too long
            $displayTitle = if ($oldTitle.Length -gt 80) { $oldTitle.Substring(0, 77) + "..." } else { $oldTitle }
            Write-Host "  Old: $displayTitle" -ForegroundColor Gray
        }
        Write-Host "  New: $NewTitle" -ForegroundColor Cyan
        
        # Replace the entire title with the new one
        $newContent = $content -replace $titlePattern, "/Title ($NewTitle)"
        
        # Convert back to bytes
        $newBytes = [System.Text.Encoding]::GetEncoding("ISO-8859-1").GetBytes($newContent)
        
        # Write the updated PDF
        [System.IO.File]::WriteAllBytes($OutputPath, $newBytes)
        
        Write-Host ""
        Write-Host "SUCCESS: PDF metadata updated!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Updated file saved as:" -ForegroundColor Yellow
        Write-Host "  $OutputPath" -ForegroundColor White
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Yellow
        Write-Host "  1. Open the updated PDF to verify it works correctly" -ForegroundColor White
        Write-Host "  2. If everything is good, replace the original file" -ForegroundColor White
        Write-Host ""
        
    } else {
        Write-Host ""
        Write-Host "Error: Could not find /Title metadata in PDF" -ForegroundColor Red
        Write-Host "The PDF may not have a title field in its metadata" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host ""
    Write-Host "Error occurred:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
