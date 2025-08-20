# Simple WebP conversion script using .NET
# This script converts PNG and JPG images to WebP format
# No external dependencies needed - uses .NET's built-in image processing

# Set the path to your assets folder
$assetsPath = "$PSScriptRoot\assets"
$processedCount = 0
$skippedCount = 0
$errorCount = 0

# Load required .NET assemblies
Add-Type -AssemblyName System.Drawing

# Function to convert image to WebP using .NET
function Convert-ToWebP {
    param (
        [string]$inputFile
    )
    
    $outputFile = [System.IO.Path]::ChangeExtension($inputFile, ".webp")
    
    # Skip if WebP version already exists and is newer than the source
    if ((Test-Path $outputFile) -and ((Get-Item $outputFile).LastWriteTime -ge (Get-Item $inputFile).LastWriteTime)) {
        Write-Host "Skipping (already exists): $inputFile" -ForegroundColor Gray
        $script:skippedCount++
        return
    }
    
    Write-Host "Converting: $inputFile" -ForegroundColor Cyan
    
    try {
        # Load the image
        $image = [System.Drawing.Image]::FromFile($inputFile)
        
        # Create encoder parameters (quality: 80%)
        $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
        $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
            [System.Drawing.Imaging.Encoder]::Quality, 
            [long]80
        )
        
        # Get WebP encoder
        $webpCodecInfo = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | 
            Where-Object { $_.MimeType -eq 'image/webp' }
        
        if ($null -eq $webpCodecInfo) {
            throw "WebP encoder not found. Make sure you have .NET 5.0 or later installed."
        }
        
        # Save as WebP
        $image.Save($outputFile, $webpCodecInfo, $encoderParams)
        $image.Dispose()
        
        Write-Host "Created: $outputFile" -ForegroundColor Green
        $script:processedCount++
    } catch {
        Write-Host "Error processing $inputFile : $_" -ForegroundColor Red
        $script:errorCount++
    }
}

# Find and convert all PNG and JPG files
Write-Host "Starting image conversion to WebP..." -ForegroundColor Yellow

Get-ChildItem -Path $assetsPath -Recurse -Include *.png, *.jpg, *.jpeg | ForEach-Object {
    Convert-ToWebP -inputFile $_.FullName
}

# Summary
Write-Host "`nConversion Summary:" -ForegroundColor Yellow
Write-Host "Converted: $processedCount files" -ForegroundColor Green
Write-Host "Skipped (already exists): $skippedCount files" -ForegroundColor Cyan
Write-Host "Errors: $errorCount files" -ForegroundColor Red

if ($processedCount -gt 0 -or $skippedCount -gt 0) {
    Write-Host "`nNote: Original files have been kept. Please update your Flutter code to use .webp files instead of .png/.jpg" -ForegroundColor Yellow
    Write-Host "After verifying the WebP files, you can delete the original .png/.jpg files to save space." -ForegroundColor Yellow
}
