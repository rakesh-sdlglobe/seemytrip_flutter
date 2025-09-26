# PowerShell script to update color imports
$files = Get-ChildItem -Path "c:\Users\Dell\Desktop\Travel Project\seemytrip_flutter\lib" -Recurse -Include "*.dart" -File

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Replace the old import with the new one
    $newContent = $content -replace "import '.*colors\.dart';", "import 'package:seemytrip/core/theme/app_colors.dart';"
    
    # Only write back if content changed
    if ($newContent -ne $content) {
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
        Write-Host "Updated imports in $($file.FullName)"
    }
}

Write-Host "Import updates complete!"
