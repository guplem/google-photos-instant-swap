# Builds the ZIP that the Chrome Web Store expects.
# Run from the project root:  powershell -ExecutionPolicy Bypass -File scripts/packageExtension.ps1
# It copies files, it never transforms them: the code in the ZIP is the code in the repository.

$projectRoot = Split-Path -Parent $PSScriptRoot

# Chrome needs only these. Everything else in the repository is development tooling, and the store
# rejects a ZIP that carries node_modules/.
$includedPaths = 'manifest.json', 'src', 'options', 'icons'

$manifest = Get-Content (Join-Path $projectRoot 'manifest.json') -Raw | ConvertFrom-Json
$version = $manifest.version

$outputDirectory = Join-Path $projectRoot 'dist'
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

$zipPath = Join-Path $outputDirectory "instant-swap-for-google-photos-$version.zip"
if (Test-Path $zipPath) {
  Remove-Item -Force $zipPath
}

# The ZIP format wants '/' between folders. Compress-Archive writes '\' on Windows, which some
# unpackers read as one long file name, so the entries are written by hand instead.
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$archive = [System.IO.Compression.ZipFile]::Open($zipPath, [System.IO.Compression.ZipArchiveMode]::Create)
try {
  foreach ($path in $includedPaths) {
    $source = Join-Path $projectRoot $path
    if (-not (Test-Path $source)) {
      throw "packageExtension: '$path' is missing from the project root."
    }
    $files = Get-ChildItem -Path $source -File -Recurse
    foreach ($file in $files) {
      $entryName = $file.FullName.Substring($projectRoot.Length + 1).Replace('\', '/')
      [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $file.FullName, $entryName) | Out-Null
    }
  }
} finally {
  $archive.Dispose()
}

$sizeInKilobytes = [math]::Round((Get-Item $zipPath).Length / 1KB, 1)
Write-Host "wrote dist/instant-swap-for-google-photos-$version.zip ($sizeInKilobytes KB)"
Write-Host 'Upload that file in the Chrome Web Store Developer Dashboard.'
