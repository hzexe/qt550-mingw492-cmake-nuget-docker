# 第一阶段：设置环境变量并运行脚本
FROM mcr.microsoft.com/windows/servercore:ltsc2019

COPY tools C:\\tools

# 设置环境变量
ENV QT_VERSION=5.5.0
ENV QT_DIR=C:\Qt\Qt5.5.0\5.5\mingw492_32
ENV Path="C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Windows\System32\OpenSSH\;C:\Users\ContainerAdministrator\AppData\Local\Microsoft\WindowsApps;C:\Qt\Qt5.5.0\5.5\mingw492_32\bin;C:\Qt\Qt5.5.0\Tools\mingw492_32\bin;C:\Program Files\CMake\bin;C:\ProgramData\nuget\bin"


RUN dir "c:/tools/"

# 运行 PowerShell 脚本
RUN powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "C:/tools/setup.ps1"


# 输出 PATH 环境变量的值
RUN cmd /c echo %Path% && qmake.exe -v &&    g++.exe --version &&    cmake --version &&    nuget.exe help && del c:\setup.ps1

# 设置工作目录
WORKDIR C:\\workspace

# 默认命令
CMD ["powershell"]
