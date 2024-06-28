@echo off
TITLE Av1an Win Script

cls

setlocal enabledelayedexpansion 

:: Set path 
set "AV1=%~dp0"

:: Set Wget command
set "Download-->=%AV1%\wget.exe -q -N --no-check-certificate --show-progress"

:: Set 7zr command
set "Extract-->=%AV1%\7zr.exe -y x"

:: Set tar command
set "Tar-->=C:\Windows\System32\tar.exe"

:: Correct path
cd "%AV1%"

echo   Installing
echo  ------------  
:: Create directories if they don't exist
for %%d in (
    ".\dependencies\av1an"
    ".\dependencies\bat"
    ".\dependencies\vapoursynth64"
    ".\dependencies\ffmpeg-7.0.1"
    ".\dependencies\ffmpeg-latest"
    ".\dependencies\mkvtoolnix"
    ".\dependencies\svt-av1"
    ".\dependencies\vmaf"
    ".\dependencies\aom"
    ".\dependencies\rav1e"
    ".\dependencies\x264"
    ".\dependencies\x265"
    ".\dependencies\vpxenc"
    ".\scripts\ffmpeg\input"
    ".\scripts\ffmpeg\input\completed-inputs"
    ".\scripts\ffmpeg\output"
    ".\scripts\ffmpeg-vp9\input"
    ".\scripts\ffmpeg-vp9\input\completed-inputs"
    ".\scripts\ffmpeg-vp9\output"
    ".\scripts\av1an-batch\input"
    ".\scripts\av1an-batch\input\completed-inputs"
    ".\scripts\av1an-batch\output"
) do if not exist "%%~d" mkdir "%%~d"

popd

:: Download portable Wget
curl -O -C - --progress-bar https://web.archive.org/web/20230511215002/https://eternallybored.org/misc/wget/1.21.4/64/wget.exe

:: Download portable 7zip
%Download-->% https://www.7-zip.org/a/7zr.exe

pushd .\dependencies\av1an

:: Download av1an
%Download-->% https://github.com/master-of-zen/Av1an/releases/download/latest/av1an.exe

cd ..\
cd .\bat

:: Download bat
%Download-->% https://github.com/sharkdp/bat/releases/download/v0.23.0/bat-v0.23.0-x86_64-pc-windows-msvc.zip -O bat.zip
%Tar-->% -xf .\bat.zip --strip-components 1 > nul
del .\bat.zip

cd ..\
cd .\ffmpeg-7.0.1

:: Download ffmpeg with shared libraries ~7.0.1
%Download-->% https://github.com/GyanD/codexffmpeg/releases/download/7.0.1/ffmpeg-7.0.1-full_build-shared.7z -O ffmpeg-release-full-shared.7z
%Extract-->% .\ffmpeg-release-full-shared.7z ffmpeg-7.0.1-full_build-shared\bin > nul

:: Move contents of bin
for /R "ffmpeg-7.0.1-full_build-shared\bin" %%f in (*) do (
    move "%%f" "%destination%" > nul
)

rmdir /s /q .\ffmpeg-7.0.1-full_build-shared

cd ..\
cd .\ffmpeg-latest

:: Download the latest ffmpeg bins 
%Download-->% https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-essentials.7z -O ffmpeg-latest.7z
%Extract-->% .\ffmpeg-latest.7z *.exe -r > nul

:: Move files out of bin
for /r %%i in (*) do (
    move "%%i" "%%~nxi" > nul
)

:: Clean up
for /d /r %%i in (*) do (
    rd /s /q "%%i" > nul
)

cd ..\

:: Download portable mkvtoolnix ~85.0
%Download-->% https://mkvtoolnix.download/windows/releases/85.0/mkvtoolnix-64-bit-85.0.7z -O mkvtoolnix.7z
%Extract-->% .\mkvtoolnix.7z > nul
del .\mkvtoolnix.7z

cd .\aom

:: Download aom av1 encoder
%Download-->% https://github.com/BlueSwordM/aom-av1-psy/releases/download/aom-av1-psy-1.0.0/Skylake.Windows.aom-av1-psy-Windows-Endless_Possibility-LTO-2022-09-06.7z
%Extract-->% Skylake.Windows.aom-av1-psy-Windows-Endless_Possibility-LTO-2022-09-06.7z > nul
MOVE /y aom-av1-psy-Windows-Endless_Possibility-Skylake-LTO-2022-09-06.exe aomenc.exe > nul

:: Add reminder about using different builds, forks, branches of encoders.
echo "If you want to use a different build or version of an encoder, just replace it using the same executable name." > readme.txt

cd ..\
cd .\vmaf

:: Download vmaf model
%Download-->% https://raw.githubusercontent.com/Netflix/vmaf/master/model/vmaf_v0.6.1neg.json
%Download-->% https://raw.githubusercontent.com/Netflix/vmaf/master/model/vmaf_4k_v0.6.1neg.json

cd ..\
cd .\x264

:: Download x264 encoder
%Download-->% https://artifacts.videolan.org/x264/release-win64/x264-r3191-4613ac3.exe -O x264.exe

:: Add reminder about using different builds, forks, branches of encoders.
echo "If you want to use a different build or version of an encoder, just replace it using the same executable name." > readme.txt

cd ..\
cd .\x265

:: Download x265 encoder
%Download-->% https://github.com/jpsdr/x265/releases/download/3.60.28/x265_r3_6_0_28.7z
%Extract-->% .\x265_r3_6_0_28.7z > nul
MOVE /y .\Winthread\Multilib\Release\x265_x64.exe x265.exe > nul
rmdir /s /q .\winthread
rmdir /s /q .\llvm
del ReadMe.txt

:: Add reminder about using different builds, forks, branches of encoders.
echo "If you want to use a different build or version of an encoder, just replace it using the same executable name." > readme.txt

cd ..\
cd .\vpxenc

:: Download vpxenc
%Download-->% https://jeremylee.sh/bins/vpx.7z
%Extract-->% .\vpx.7z vpxenc.exe > nul

cd ..\
cd .\rav1e

:: Download rav1e
%Download-->% https://github.com/xiph/rav1e/releases/latest/download/rav1e.exe

cd ..\
cd .\vapoursynth64

:: Download embedded Python ~3.12.4
%Download-->% https://www.python.org/ftp/python/3.12.4/python-3.12.4-embed-amd64.zip
%Tar-->% -xf .\python-3.12.4-embed-amd64.zip
del .\python-3.12.4-embed-amd64.zip

:: Download VapourSynth64 Portable ~R68
%Download-->% https://github.com/vapoursynth/vapoursynth/releases/download/R68/VapourSynth64-Portable-R68.zip
%Tar-->% -xf .\VapourSynth64-Portable-R68.zip > nul
del .\VapourSynth64-Portable-R68.zip

:: install pip
echo import site >> python312._pth
%Download-->% https://bootstrap.pypa.io/get-pip.py
.\python.exe get-pip.py --no-warn-script-location > nul

:: install VapourSynth64 wheel
.\Scripts\pip.exe install .\wheel\VapourSynth-68-cp312-cp312-win_amd64.whl --no-warn-script-location  > nul

:: Download plugins
 .\python.exe .\vsrepo.py update -p  > nul
 .\python.exe .\vsrepo.py install lsmas ffms2 bestsource -p  > nul

cd ..\
cd .\svt-av1

:: Uncomment to grab from build artifacts

:: Download SVT-AV1 release ~2.0.0; Artifacts sometimes expire
:: curl -sLf "https://gitlab.com/AOMediaCodec/SVT-AV1/-/jobs/6387649298/artifacts/download?file_type=archive" -O NUL -w "%%{url_effective}" > ./raw.txt

:: Grab link
:: (for /f "usebackq delims=" %%a in ("raw.txt") do (
::     set "line=%%a"
::     set "line=!line:~0,-11!"
::     echo !line!
:: )) > "downloadlink.txt"

:: %Download-->% -i .\downloadlink.txt -O SVT-AV1-2.0.zip

:: Clean up
:: del download > nul 2>&1
:: del downloadlink.txt > nul
:: del raw.txt > nul

:: %Tar-->% -xf .\SVT-AV1-2.0.zip --strip-components 2 > nul

:: Download SVT-AV1-PSY release ~2.1.0-A
%Download-->% https://github.com/gianni-rosato/svt-av1-psy/releases/download/v2.1.0-A/SvtAv1EncApp-Windows-x64.7z -O SvtAv1EncApp-psy.7z
%Tar-->% -xf .\SvtAv1EncApp-psy.7z SvtAv1EncApp.exe > nul

:: Add reminder about using different builds, forks, branches of encoders.
echo "If you want to use a different build or version of an encoder, just replace it using the same executable name." > readme.txt

popd

:: Clean up
del .wget-hsts > nul
del wget.exe > nul
del 7zr.exe > nul
del preview.webp > nul

echo:
echo Installation Finished
echo:   Exiting...
echo:
PAUSE
