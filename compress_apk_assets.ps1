# Set paths
$apkPath = "build\app\outputs\flutter-apk\app-release.apk"
$tempDir = "$PSScriptRoot\tmp_apk"
$webpConverter = "cwebp"  # Needs to be installed & in PATH (https://developers.google.com/speed/webp/docs/precompiled)

# Check WebP converter
try {
    $null = Get-Command $webpConverter -ErrorAction Stop
} catch {
    Write-Host "Error: cwebp not found in PATH. Install it first." -ForegroundColor Red
    exit 1
}

# Prepare temp directory
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
New-Item -ItemType Directory -Path $tempDir | Out-Null

# Copy & unzip APK
Copy-Item $apkPath "$tempDir\app.zip"
Expand-Archive "$tempDir\app.zip" -DestinationPath "$tempDir\unpacked"

# Find largest image files in assets/flutter_assets
Write-Host "`n=== Largest asset files (before compression) ===" -ForegroundColor Cyan
$assetsPath = "$tempDir\unpacked\assets\flutter_assets"
Get-ChildItem $assetsPath -Recurse -Include *.png, *.jpg, *.jpeg |
Sort-Object Length -Descending |
Select-Object Name, @{Name="SizeMB";Expression={[math]::Round($_.Length / 1MB, 2)}} -First 20 |
Format-Table -AutoSize

# Convert images to WebP
Get-ChildItem $assetsPath -Recurse -Include *.png, *.jpg, *.jpeg | ForEach-Object {
    $outputFile = [System.IO.Path]::ChangeExtension($_.FullName, ".webp")
    & $webpConverter -q 75 $_.FullName -o $outputFile | Out-Null
    Remove-Item $_.FullName -Force
}

Write-Host "`nConversion complete! Repacking APK..." -ForegroundColor Green

# Repack APK
Compress-Archive -Path "$tempDir\unpacked\*" -DestinationPath "$tempDir\app-release-compressed.zip"
Rename-Item "$tempDir\app-release-compressed.zip" "app-release-compressed.apk"

Write-Host "`nNew APK created: $tempDir\app-release-compressed.apk" -ForegroundColor Green

# Show new sizes
Write-Host "`n=== New asset sizes (after compression) ===" -ForegroundColor Cyan
Get-ChildItem $assetsPath -Recurse -Include *.webp |
Sort-Object Length -Descending |
Select-Object Name, @{Name="SizeMB";Expression={[math]::Round($_.Length / 1MB, 2)}} -First 20 |
Format-Table -AutoSize
