# Renders the 1280x800 screenshots that the Chrome Web Store listing shows.
# Run from the project root:  powershell -ExecutionPolicy Bypass -File scripts/makeStoreScreenshots.ps1
# A still image cannot show a missing animation, so two of the three images explain the change instead
# of claiming to be a capture. The options page image is the real page, rendered by Chrome itself.

Add-Type -AssemblyName System.Drawing

$projectRoot = Split-Path -Parent $PSScriptRoot
$sourcesDirectory = Join-Path $projectRoot 'store/screenshotSources'
$outputDirectory = Join-Path $projectRoot 'store/screenshots'
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

$chromePaths = "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
  "$env:LocalAppData\Google\Chrome\Application\chrome.exe"
$chrome = $chromePaths | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $chrome) {
  throw 'makeStoreScreenshots: Chrome is not installed in any of the usual folders.'
}

# Headless Chrome refuses to share the profile of a running Chrome, so every render gets its own.
$workingDirectory = Join-Path $env:TEMP 'instantSwapScreenshots'
if (Test-Path $workingDirectory) {
  Remove-Item -Recurse -Force $workingDirectory
}
New-Item -ItemType Directory -Force -Path $workingDirectory | Out-Null

function Invoke-ChromeScreenshot {
  param(
    [string]$PageUrl,
    [string]$ImagePath,
    [int]$Width,
    [int]$Height
  )
  $profileDirectory = Join-Path $workingDirectory ([System.Guid]::NewGuid().ToString('N'))
  & $chrome --headless=new --disable-gpu --hide-scrollbars --allow-file-access-from-files `
    --user-data-dir="$profileDirectory" --window-size="$Width,$Height" `
    --screenshot="$ImagePath" $PageUrl | Out-Null
  if (-not (Test-Path $ImagePath)) {
    throw "makeStoreScreenshots: Chrome wrote no image for $PageUrl."
  }
}

function ConvertTo-FileUrl {
  param([string]$Path)
  return 'file:///' + ($Path -replace '\\', '/')
}

# The real options page needs two edits before Chrome can render it outside the extension: its script
# calls chrome.storage, which does not exist here, and the form would then show empty values instead
# of the real defaults from DEFAULT_SETTINGS.
$optionsPage = Get-Content (Join-Path $projectRoot 'options/optionsPage.html') -Raw
$optionsStylesheet = ConvertTo-FileUrl (Join-Path $projectRoot 'options/optionsPage.css')
$optionsPage = $optionsPage.Replace('href="optionsPage.css"', "href=`"$optionsStylesheet`"")
$optionsPage = $optionsPage.Replace('<script type="module" src="optionsPage.js"></script>', '')
$optionsPage = $optionsPage.Replace('id="instantSwapEnabled" />', 'id="instantSwapEnabled" checked />')
$optionsPage = $optionsPage.Replace('id="patchReducedMotion" />', 'id="patchReducedMotion" checked />')
$optionsPagePath = Join-Path $workingDirectory 'optionsPage.html'
Set-Content -Path $optionsPagePath -Value $optionsPage -Encoding utf8

$optionsImagePath = Join-Path $workingDirectory 'optionsPageFull.png'
Invoke-ChromeScreenshot -PageUrl (ConvertTo-FileUrl $optionsPagePath) -ImagePath $optionsImagePath -Width 760 -Height 640

# The page is shorter than the window, so the empty space below the buttons is cut away.
$fullImage = [System.Drawing.Image]::FromFile($optionsImagePath)
$croppedImage = New-Object System.Drawing.Bitmap(760, 468)
$croppedGraphics = [System.Drawing.Graphics]::FromImage($croppedImage)
$cropArea = New-Object System.Drawing.Rectangle(0, 0, 760, 468)
$croppedGraphics.DrawImage($fullImage, $cropArea, $cropArea, [System.Drawing.GraphicsUnit]::Pixel)
$croppedImage.Save((Join-Path $sourcesDirectory 'optionsPageCropped.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$croppedGraphics.Dispose()
$croppedImage.Dispose()
$fullImage.Dispose()

$screenshots = [ordered]@{
  'shot1Compare.html' = 'screenshot1WhatItChanges.png'
  'shot2Options.html' = 'screenshot2OptionsPage.png'
  'shot3Privacy.html' = 'screenshot3Privacy.png'
}

foreach ($sourceName in $screenshots.Keys) {
  $imageName = $screenshots[$sourceName]
  $imagePath = Join-Path $outputDirectory $imageName
  Invoke-ChromeScreenshot -PageUrl (ConvertTo-FileUrl (Join-Path $sourcesDirectory $sourceName)) `
    -ImagePath $imagePath -Width 1280 -Height 800
  Write-Host "wrote store/screenshots/$imageName"
}

Remove-Item -Recurse -Force $workingDirectory
