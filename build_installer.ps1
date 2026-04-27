# Retail SaaS Windows Installer Build Script
# This script automates the creation of the Windows installer (.exe)

Write-Host "--- Starting Retail SaaS Installer Build ---" -ForegroundColor Cyan

# 1. Fetch dependencies
Write-Host "[1/4] Fetching dependencies..." -ForegroundColor Yellow
flutter pub get

# 2. Generate Icon
Write-Host "[2/4] Generating application icon..." -ForegroundColor Yellow
dart scripts/create_ico.dart

# 3. Build Windows App
Write-Host "[3/4] Building Flutter Windows app (Release)..." -ForegroundColor Yellow
flutter build windows --release

# 4. Create Installer
Write-Host "[4/4] Creating Windows Installer (.exe)..." -ForegroundColor Yellow
dart run inno_bundle:build

Write-Host "--- Build Process Complete ---" -ForegroundColor Green
Write-Host "The installer should be available in: build/windows/x64/installer/" -ForegroundColor White
