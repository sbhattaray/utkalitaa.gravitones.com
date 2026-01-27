# PowerShell script to update PDF metadata
# This script modifies the PDF title directly

param(
    [string]$PdfPath = "$PSScriptRoot\Admission.pdf",
    [string]$NewTitle = "Day Care Admission Form"
)

Write-Host "PDF Title Updater" -ForegroundColor Cyan
Write-Host "==================`n" -ForegroundColor Cyan

# Read PDF binary content
Write-Host "Reading PDF file..." -ForegroundColor Yellow
$bytes = [System.IO.File]::ReadAllBytes($PdfPath)
$content = [System.Text.Encoding]::Latin1.GetString($bytes)

# Find the title metadata in the PDF
$titlePattern = '/Title\s*\([^)]+\)'
if ($content -match $titlePattern) {
    Write-Host "Found existing title metadata" -ForegroundColor Green
    
    # Extract the old title for display
    $oldTitleMatch = [regex]::Match($content, '/Title\s*\(([^)]+)\)')
    if ($oldTitleMatch.Success) {
        $oldTitle = $oldTitleMatch.Groups[1].Value
        Write-Host "Old title: $oldTitle" -ForegroundColor Gray
    }
    
    # Replace the title
    $newTitleEscaped = $NewTitle -replace '([\\()])', '\$1'  # Escape special chars
    $newContent = $content -replace '/Title\s*\([^)]+\)', "/Title ($newTitleEscaped)"
    
    # Write the updated PDF
    $outputPath = $PdfPath -replace '\.pdf$', '_updated.pdf'
    [System.IO.File]::WriteAllBytes($outputPath, [System.Text.Encoding]::Latin1.GetBytes($newContent))
    
    Write-Host "`n✓ PDF metadata updated successfully!" -ForegroundColor Green
    Write-Host "✓ New title: $NewTitle" -ForegroundColor Green
    Write-Host "`nUpdated file saved as:" -ForegroundColor Cyan
    Write-Host $outputPath -ForegroundColor White
    Write-Host "`nNext steps:" -ForegroundColor Yellow
    Write-Host "1. Verify the updated PDF opens correctly"
    Write-Host "2. If everything looks good, replace the original:"
    Write-Host "   Remove-Item '$PdfPath'"
    Write-Host "   Rename-Item '$outputPath' 'Admission.pdf'"
    
} else {
    Write-Host "Error: Could not find title metadata in PDF" -ForegroundColor Red
    Write-Host "The PDF structure might be different than expected" -ForegroundColor Yellow
}
