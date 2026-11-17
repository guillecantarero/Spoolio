$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
Push-Location $projectRoot
try {
    $portableJdk = Get-ChildItem '.android-tools/jdk' -Directory -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($portableJdk) { $env:JAVA_HOME = $portableJdk.FullName }
    if (Test-Path '.android-tools/sdk') {
        $sdkPath = (Resolve-Path '.android-tools/sdk').Path.Replace('\', '/')
        Set-Content -LiteralPath 'android/local.properties' -Value "sdk.dir=$sdkPath" -Encoding ascii
        $env:GRADLE_USER_HOME = Join-Path $projectRoot '.android-tools/gradle-cache'
    }
    npm run android:sync
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo preparar la interfaz Android.' }
    & './android/gradlew.bat' -p android :app:assembleDebug --console=plain --max-workers=1 --no-daemon --no-watch-fs
    if ($LASTEXITCODE -ne 0) { throw 'La compilación Android ha fallado.' }
    New-Item -ItemType Directory -Path 'artifacts' -Force | Out-Null
    Copy-Item -LiteralPath 'android/app/build/outputs/apk/debug/app-debug.apk' -Destination 'artifacts/Spoolio-debug.apk' -Force
    Get-FileHash -LiteralPath 'artifacts/Spoolio-debug.apk' -Algorithm SHA256
    Write-Output "APK: $projectRoot/artifacts/Spoolio-debug.apk"
} finally { Pop-Location }
