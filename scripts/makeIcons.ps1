# Draws the extension icons.
# Run from the project root:  powershell -ExecutionPolicy Bypass -File scripts/makeIcons.ps1
# The artwork shows what the extension does: two photos, and one arrow that points both ways.

Add-Type -AssemblyName System.Drawing

$source = 512
$bitmap = New-Object System.Drawing.Bitmap($source, $source)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.Clear([System.Drawing.Color]::Transparent)

function New-RoundedRectanglePath {
  param(
    [int]$Left,
    [int]$Top,
    [int]$Width,
    [int]$Height,
    [int]$CornerRadius
  )
  $diameter = $CornerRadius * 2
  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $path.AddArc($Left, $Top, $diameter, $diameter, 180, 90)
  $path.AddArc($Left + $Width - $diameter, $Top, $diameter, $diameter, 270, 90)
  $path.AddArc($Left + $Width - $diameter, $Top + $Height - $diameter, $diameter, $diameter, 0, 90)
  $path.AddArc($Left, $Top + $Height - $diameter, $diameter, $diameter, 90, 90)
  $path.CloseFigure()
  return $path
}

# Dark rounded square background.
$background = New-RoundedRectanglePath -Left 0 -Top 0 -Width $source -Height $source -CornerRadius ([int]($source * 0.22))
$backgroundBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 32, 33, 36))
$graphics.FillPath($backgroundBrush, $background)

$amber = [System.Drawing.Color]::FromArgb(255, 255, 179, 0)

# Two photo frames, side by side.
$framePen = New-Object System.Drawing.Pen $amber, 34
$framePen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$leftFrame = New-RoundedRectanglePath -Left 64 -Top 76 -Width 164 -Height 164 -CornerRadius 26
$rightFrame = New-RoundedRectanglePath -Left 284 -Top 76 -Width 164 -Height 164 -CornerRadius 26
$graphics.DrawPath($framePen, $leftFrame)
$graphics.DrawPath($framePen, $rightFrame)

# One arrow that points both ways, under the frames.
$arrowPen = New-Object System.Drawing.Pen $amber, 40
$arrowPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$arrowPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$arrowPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

$graphics.DrawLine($arrowPen, 150, 384, 362, 384)
$graphics.DrawLines($arrowPen, @(
  (New-Object System.Drawing.Point(202, 332)),
  (New-Object System.Drawing.Point(150, 384)),
  (New-Object System.Drawing.Point(202, 436))
))
$graphics.DrawLines($arrowPen, @(
  (New-Object System.Drawing.Point(310, 332)),
  (New-Object System.Drawing.Point(362, 384)),
  (New-Object System.Drawing.Point(310, 436))
))

$outputDirectory = Join-Path (Split-Path -Parent $PSScriptRoot) 'icons'
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

foreach ($size in 16, 32, 48, 128) {
  $scaled = New-Object System.Drawing.Bitmap($size, $size)
  $scaledGraphics = [System.Drawing.Graphics]::FromImage($scaled)
  $scaledGraphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $scaledGraphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $scaledGraphics.DrawImage($bitmap, 0, 0, $size, $size)
  $scaled.Save((Join-Path $outputDirectory "icon$size.png"), [System.Drawing.Imaging.ImageFormat]::Png)
  $scaledGraphics.Dispose()
  $scaled.Dispose()
  Write-Host "wrote icon$size.png"
}


$graphics.Dispose()
$bitmap.Dispose()
