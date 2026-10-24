$ErrorActionPreference = 'Stop'
$folder = Join-Path $PSScriptRoot 'mediapipe'
New-Item -ItemType Directory -Force -Path $folder | Out-Null
$base = 'https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision@0.10.22'
$files = @(
  @{Name='vision_bundle.js'; URL="$base/vision_bundle.js"},
  @{Name='vision_wasm_internal.wasm'; URL="$base/wasm/vision_wasm_internal.wasm"},
  @{Name='vision_wasm_internal.js'; URL="$base/wasm/vision_wasm_internal.js"},
  @{Name='vision_wasm_nosimd_internal.wasm'; URL="$base/wasm/vision_wasm_nosimd_internal.wasm"},
  @{Name='vision_wasm_nosimd_internal.js'; URL="$base/wasm/vision_wasm_nosimd_internal.js"},
  @{Name='hand_landmarker.task'; URL='https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task'}
)
foreach ($f in $files) {
  $dest = Join-Path $folder $f.Name
  Write-Host "Downloading $($f.Name)..."
  try { Invoke-WebRequest -Uri $f.URL -OutFile $dest -UseBasicParsing -TimeoutSec 90 }
  catch { Write-Host "FAILED: $($f.URL)"; throw }
  if ((Get-Item $dest).Length -lt 1000) { throw "Downloaded file is too small: $dest" }
}
Write-Host 'Done! Upload index.html and the mediapipe folder to GitHub.' -ForegroundColor Green
