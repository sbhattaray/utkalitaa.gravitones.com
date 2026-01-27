# PowerShell script to update PDF title using iTextSharp
# First, we'll try to use PDFtk or install necessary tools

$pdfPath = "c:\Users\Rahul\Downloads\Utkalitta Day Care\utkalitaa.gravitones.com\utkalitaa.gravitones.com\Data\Admission.pdf"
$outputPath = "c:\Users\Rahul\Downloads\Utkalitta Day Care\utkalitaa.gravitones.com\utkalitaa.gravitones.com\Data\Admission_new.pdf"
$newTitle = "Day Care Admission Form - Delhi Technological University"

# Try using exiftool if available
$exiftool = Get-Command exiftool -ErrorAction SilentlyContinue
if ($exiftool) {
    Write-Host "Using exiftool to update PDF title..."
    exiftool -Title="$newTitle" -overwrite_original "$pdfPath"
    Write-Host "PDF title updated successfully!"
} else {
    Write-Host "exiftool not found. Please install it or use an alternative method."
    Write-Host "You can download exiftool from: https://exiftool.org/"
    Write-Host ""
    Write-Host "Alternative: Install via chocolatey:"
    Write-Host "choco install exiftool"
}
