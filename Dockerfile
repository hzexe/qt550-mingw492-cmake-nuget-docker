# 使用 Windows Server Core 作为基础镜像
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# 设置环境变量
ENV QT_DIR=C:\Qt\Qt5.5.0\5.5\mingw492_32

# 设置完整的环境变量
ENV Path="C:\Qt\Qt5.5.0\5.5\mingw492_32\bin;C:\Qt\Qt5.5.0\5.5\mingw492_32\tools\mingw492_32\bin;C:\Program Files\CMake\bin;C:\ProgramData\nuget\bin;%Path%"

# 复制 Qt 文件夹
COPY Qt C:
COPY tools C:\\tools

# 运行 PowerShell 脚本
RUN powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command C:\\tools\\setup.ps1

# 设置工作目录
WORKDIR C:\\workspace

# 默认命令
CMD ["powershell"]
