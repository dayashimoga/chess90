@echo off
setlocal
cd /d "%~dp0"

:: Check if running from temporary extraction directory or unextracted zip
if not exist "%~dp0flutter_windows.dll" (
    echo ======================================================
    echo [ERROR] flutter_windows.dll was not found!
    echo ======================================================
    echo.
    echo Please make sure you have EXTRACTED the ZIP file completely
    echo before running ChessMaster.
    echo.
    echo Running directly from inside Windows Explorer's ZIP preview
    echo is not supported by Windows dynamic link libraries.
    echo.
    pause
    exit /b 1
)

if not exist "%~dp0data" (
    echo ======================================================
    echo [ERROR] The 'data' folder was not found!
    echo ======================================================
    echo Please make sure you have extracted all files from the ZIP archive.
    echo.
    pause
    exit /b 1
)

if exist "%~dp0ChessMaster.exe" (
    start "" "%~dp0ChessMaster.exe" %*
) else (
    if exist "%~dp0chess_app.exe" (
        start "" "%~dp0chess_app.exe" %*
    ) else (
        echo [ERROR] Neither ChessMaster.exe nor chess_app.exe found!
        pause
        exit /b 1
    )
)
