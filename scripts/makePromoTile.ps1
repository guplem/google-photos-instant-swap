# Draws the 440x280 promo tile that the Chrome Web Store listing shows.
# Run from the project root:  powershell -ExecutionPolicy Bypass -File scripts/makePromoTile.ps1
# It places the icon file itself on the tile, so the tile can never drift from the icon artwork.

Add-Type -AssemblyName System.Drawing

$projectRoot = Split-Path -Parent $PSScriptRoot
$iconPath = Join-Path $projectRoot 'icons/icon128.png'
if (-not (Test-Path $iconPath)) {
  throw 'makePromoTile: icons/icon128.png is missing. Run scripts/makeIcons.ps1 first.'
}

$width = 440
$height = 280
$bitmap = New-Object System.Drawing.Bitmap($width, $height)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

$dark = [System.Drawing.Color]::FromArgb(255, 32, 33, 36)
$amber = [System.Drawing.Color]::FromArgb(255, 255, 179, 0)
$white = [System.Drawing.Color]::FromArgb(255, 255, 255, 255)
$grey = [System.Drawing.Color]::FromArgb(255, 189, 193, 198)

$backgroundBrush = New-Object System.Drawing.SolidBrush $dark
$graphics.FillRectangle($backgroundBrush, 0, 0, $width, $height)

# The store crops a few pixels on some screens, so nothing important sits near the edge.
$icon = [System.Drawing.Image]::FromFile($iconPath)
$graphics.DrawImage($icon, 40, 76, 128, 128)

$titleFont = New-Object System.Drawing.Font('Segoe UI', 30, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
$subtitleFont = New-Object System.Drawing.Font('Segoe UI', 19, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
$taglineFont = New-Object System.Drawing.Font('Segoe UI', 15, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)

$amberBrush = New-Object System.Drawing.SolidBrush $amber
$whiteBrush = New-Object System.Drawing.SolidBrush $white
$greyBrush = New-Object System.Drawing.SolidBrush $grey

$graphics.DrawString('Instant Swap', $titleFont, $amberBrush, 196, 78)
$graphics.DrawString('for Google Photos', $subtitleFont, $whiteBrush, 198, 118)
$graphics.DrawString('No slide between photos.', $taglineFont, $greyBrush, 199, 156)
$graphics.DrawString('Compare them with the arrow keys.', $taglineFont, $greyBrush, 199, 178)

$outputDirectory = Join-Path $projectRoot 'store'
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
$bitmap.Save((Join-Path $outputDirectory 'promoTileSmall440x280.png'), [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host 'wrote store/promoTileSmall440x280.png'

$titleFont.Dispose()
$subtitleFont.Dispose()
$taglineFont.Dispose()
$amberBrush.Dispose()
$whiteBrush.Dispose()
$greyBrush.Dispose()
$backgroundBrush.Dispose()
$icon.Dispose()
$graphics.Dispose()
$bitmap.Dispose()
