# Convert images to WebP script for Flutter assets
# Prerequisites: Install WebP converter from Google (https://developers.google.com/speed/webp/docs/precompiled)
# Make sure to add the WebP converter to your system PATH

# Set the path to your assets folder
$assetsPath = "$PSScriptRoot\assets"
$webpConverter = "cwebp" # Assumes cwebp is in your PATH

# Check if cwebp is installed
try {
    $null = Get-Command $webpConverter -ErrorAction Stop
} catch {
    Write-Host "Error: WebP converter (cwebp) not found. Please install it from https://developers.google.com/speed/webp/docs/precompiled" -ForegroundColor Red
    exit 1
}

# Create a backup of original files (uncomment if needed)
# $backupPath = "$assetsPath\backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
# if (-not (Test-Path $backupPath)) { New-Item -ItemType Directory -Path $backupPath | Out-Null }
# Copy-Item -Path "$assetsPath\*" -Include *.png,*.jpg,*.jpeg -Destination $backupPath -Recurse -Force

# Function to convert image to WebP
function Convert-ToWebP {
    param (
        [string]$inputFile
    )
    
    $outputFile = [System.IO.Path]::ChangeExtension($inputFile, ".webp")
    
    # Skip if WebP version already exists and is newer than the source
    if ((Test-Path $outputFile) -and ((Get-Item $outputFile).LastWriteTime -ge (Get-Item $inputFile).LastWriteTime)) {
        Write-Host "Skipping (already converted): $inputFile" -ForegroundColor Gray
        return
    }
    
    Write-Host "Converting: $inputFile" -ForegroundColor Cyan
    
    try {
        # Convert to WebP with quality 80 (adjust as needed)
        & $webpConverter -q 80 "$inputFile" -o "$outputFile"
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Created: $outputFile" -ForegroundColor Green
            # Optionally delete original file after successful conversion (uncomment to enable)
            # Remove-Item $inputFile -Force
        } else {
            Write-Host "Error converting $inputFile" -ForegroundColor Red
        }
    } catch {
        Write-Host "Error processing $inputFile : $_" -ForegroundColor Red
    }
}

# Find and convert all PNG and JPG files
Get-ChildItem -Path $assetsPath -Recurse -Include *.png, *.jpg, *.jpeg | ForEach-Object {
    Convert-ToWebP -inputFile $_.FullName
}

Write-Host "\nConversion complete!"
