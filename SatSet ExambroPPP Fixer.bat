@echo off
setlocal EnableDelayedExpansion
mode con: cols=80 lines=30
color a
:: ==== CEK ADMIN ====
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Memerlukan hak Administrator. Membuka ulang dengan hak admin...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

echo ======================================
echo.
echo     Sat Set ExamBrowserBPPP Fixer
echo.
echo        by The Next Level Ops
echo.
echo      Youtube @thenextlevelops
echo.
echo ======================================
echo.
echo Silahkan tekan sembarang untuk lanjut
echo.
echo ** Dilarang mengedit code tanpa seizin Pemilik **
echo.
pause
cls

:: ==== DETEKSI BIT ====
set "arch=x86"
if defined ProgramFiles(x86) set "arch=x64"
echo Arsitektur: %arch%

:: ==== DETEKSI WINDOWS ====
for /f "tokens=4-5 delims=. " %%i in ('ver') do (
    set "ver_major=%%i"
    set "ver_minor=%%j"
)
set "win_version=Unknown"
if "!ver_major!"=="6" (
    if "!ver_minor!"=="2" (
        set "win_version=Windows 8"
        echo Deteksi: !win_version!
        echo Windows 8 tidak didukung. Silakan upgrade ke Windows 10.
        start https://youtu.be/xx6Vtva8BwU
        pause
        exit /b
    )
    if "!ver_minor!"=="3" set "win_version=Windows 8.1"
)
if "!ver_major!"=="10" set "win_version=Windows 10 or 11"
echo Versi Windows: !win_version!

:: ==== CEK LOKASI INSTALL ====
set "targetPath="
set "tmpexmb=%windir%\exambppp"

if exist "C:\Program Files (x86)\ExamBrowserBPPP\reference" (
    set "targetPath=C:\Program Files (x86)\ExamBrowserBPPP\reference"
)
if exist "C:\Program Files\ExamBrowserBPPP\reference" (
    set "targetPath=C:\Program Files\ExamBrowserBPPP\reference"
)

if not defined targetPath (
    echo Folder ExamBrowserBPPP tidak ditemukan, akan mengunduh instalasi...
    if not exist "%tmpexmb%" (mkdir "%tmpexmb%" )

        echo.
        echo Donwload ExamBrowserBPPP ... !!

    if "%arch%"=="x64" (
        curl -L -o "%tmpexmb%\ExamBrowserSetup_x64.msi" "https://unduhexam.bppp.kemdikbud.go.id/autoupdateabm/ExamBrowserSetup_x64.msi"
        echo.
        echo Sedang menginstall ExamBrowserBPPP...
        echo.
        start "" /wait msiexec /i "%tmpexmb%\ExamBrowserSetup_x64.msi" /qn
        echo Selesai
    ) else (
        echo.
        echo Sedang menginstall ExamBrowserBPPP...
        echo.
        curl -L -o "%tmpexmb%\ExamBrowserSetup_x86.msi" "https://unduhexam.bppp.kemdikbud.go.id/autoupdateabm/ExamBrowserSetup_x86.msi"
        start "" /wait msiexec /i "%tmpexmb%\ExamBrowserSetup_x86.msi" /qn
        echo Selesai
    )

    :: Coba deteksi ulang setelah install
    if exist "C:\Program Files (x86)\ExamBrowserBPPP\reference" (
        set "targetPath=C:\Program Files (x86)\ExamBrowserBPPP\reference"
    )
    if exist "C:\Program Files\ExamBrowserBPPP\reference" (
        set "targetPath=C:\Program Files\ExamBrowserBPPP\reference"
    )
)

if not defined targetPath (
    echo Gagal menemukan atau menginstal ExamBrowserBPPP.
    pause
    exit /b
)

:: ==== CEK D3DCOMPILER_47.DLL ====
rem if not exist "%windir%\System32\d3dcompiler_47.dll" (
rem    echo File d3dcompiler_47.dll tidak ditemukan. Mengunduh Visual C++ Redistributable...
    if not exist "%tmpexmb%" (mkdir "%tmpexmb%" )
    
    if "%arch%"=="x64" (
        echo.
        echo Donwload Vcredist x64 ... !!
        curl -L -o "%tmpexmb%\vc_redist.x64.exe" "https://aka.ms/vs/17/release/vc_redist.x64.exe"
        echo.
        echo Install Vcredist ... !!
        start "" /wait "%tmpexmb%\vc_redist.x64.exe" /quiet /norestart
    ) 
rem    else (
        echo.
        echo Donwload Vcredist x86 ... !!
        echo.
        curl -L -o "%tmpexmb%\vc_redist.x86.exe" "https://aka.ms/vs/17/release/vc_redist.x86.exe"
        echo Install Vcredist ... !!
        start "" /wait "%tmpexmb%\vc_redist.x86.exe" /quiet /norestart
        echo.
        echo Selesai
rem    )
rem )

:: ==== MATIKAN exam.exe JIKA BERJALAN ====
taskkill /f /im exam.exe >nul 2>&1

:: ==== SALIN DLL ====
echo.
echo *******    Patching    ********
copy /Y "%windir%\System32\d3dcompiler_47.dll" "!targetPath!" >nul

if %errorlevel%==0 (
    echo.
    echo Sukses ! : ExamBrowserBPPP berhasil di Patch !
    echo.
) else (
    color c
    echo.
    echo Gagal ! : ExamBrowserBPPP gagal di Patch !
    echo.
    pause
    exit /b
)

:: ==== JALANKAN EXAM.EXE ====
if exist "!targetPath!\exam.exe" (
    echo Menjalankan ExamBrowserBPPP
    echo.
    start "" "!targetPath!\exam.exe"
) else (
    echo exam.exe tidak ditemukan di !targetPath!
)

pause
pause
cls
echo      Terimakasih Telah Berkunjung
echo   Semoga lancar ujiannya dan lulus
echo.
echo             Salam OPS
echo.
pause
pause
start https://www.youtube.com/@nextlevelops
