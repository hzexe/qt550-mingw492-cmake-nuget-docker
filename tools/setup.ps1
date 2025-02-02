# 设置错误处理
$ErrorActionPreference = 'Stop'

function DownloadWithRetry {
    param (
        [string]$Url,
        [string]$OutputFile,
        [int]$MaxRetries = 3,
        [int]$RetryInterval = 5
    )

    # 确保输出文件的目录存在
    $outputDir = Split-Path -Parent $OutputFile
    if (-not (Test-Path $outputDir)) {
        Write-Host "Creating directory: $outputDir"
        New-Item -ItemType Directory -Path $outputDir -Force
    }

    for ($i = 0; $i -lt $MaxRetries; $i++) {
        try {
            Write-Host "Downloading $Url to $OutputFile (Attempt $i)..."
            if (Test-Path $OutputFile) {
                $bytesReceived = (Get-Item $OutputFile).Length
                Invoke-WebRequest -Uri $Url -OutFile $OutputFile -Method Get -Headers @{"Range" = "bytes=$bytesReceived-"}
            } else {
                Invoke-WebRequest -Uri $Url -OutFile $OutputFile -Method Get
            }
            if (Test-Path $OutputFile) {
                return
            }
        } catch {
            Write-Host "Download failed. Retrying in $RetryInterval seconds..."
            Start-Sleep -Seconds $RetryInterval
        }
    }

    throw "Failed to download $Url after $MaxRetries attempts."
}

try {
    # 下载并安装 CMake
    Write-Host "Downloading and installing CMake..."
    $cmakeMsi = 'C:\cmake.msi'
    DownloadWithRetry -Url 'https://github.com/Kitware/CMake/releases/download/v3.30.2/cmake-3.30.2-windows-x86_64.msi' -OutputFile $cmakeMsi
    Start-Process -FilePath 'msiexec' -ArgumentList "/i $cmakeMsi /quiet" -Wait -ErrorAction Stop
    Remove-Item -Force $cmakeMsi -ErrorAction Stop

    # 下载并安装 NuGet
    Write-Host "Downloading and installing NuGet..."
    $nugetExe = 'C:\ProgramData\nuget\bin\nuget.exe'
    DownloadWithRetry -Url 'https://dist.nuget.org/win-x86-commandline/latest/nuget.exe' -OutputFile $nugetExe

    # 验证安装
    Write-Host "Verifying installations..."
    qmake.exe -v
    g++.exe --version
    cmake --version
    nuget.exe

    Write-Host "Setup completed successfully."
} catch {
    Write-Host "An error occurred: $_"
    exit 1
}
