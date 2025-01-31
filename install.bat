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
    ".\dependencies\ffmpeg-7.0.2"
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
%Download-->% https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-pc-windows-msvc.zip -O bat.zip
%Tar-->% -xf .\bat.zip --strip-components 1 > nul
del .\bat.zip

cd ..\
cd .\ffmpeg-7.0.2

:: Download ffmpeg with shared libraries ~7.0.2
%Download-->% https://github.com/GyanD/codexffmpeg/releases/download/7.0.2/ffmpeg-7.0.2-full_build-shared.7z -O ffmpeg-release-full-shared.7z
%Extract-->% .\ffmpeg-release-full-shared.7z ffmpeg-7.0.2-full_build-shared\bin > nul

:: Move contents of bin
for /R "ffmpeg-7.0.2-full_build-shared\bin" %%f in (*) do (
    move "%%f" "%destination%" > nul
)

rmdir /s /q .\ffmpeg-7.0.2-full_build-shared

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

:: Download portable mkvtoolnix ~88.0
%Download-->% https://mkvtoolnix.download/windows/releases/88.0/mkvtoolnix-64-bit-88.0.7z -O mkvtoolnix.7z
%Extract-->% .\mkvtoolnix.7z > nul
del .\mkvtoolnix.7z

cd .\aom

:: Download aom-psy101 encoder (aom-av1 fork)
%Download-->% https://github.com/Uranite/aom-psy101-win-build/releases/download/latest/aom_build.7z
%AV1%\7zr.exe -y e .\aom_build.7z x86-64\aomenc.exe > nul

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
%Download-->% https://artifacts.videolan.org/x264/release-win64/x264-r3198-da14df5.exe -O x264.exe

:: Add reminder about using different builds, forks, branches of encoders.
echo "If you want to use a different build or version of an encoder, just replace it using the same executable name." > readme.txt

cd ..\
cd .\x265

:: Download x265 encoder
%Download-->% https://github.com/jpsdr/x265/releases/download/4.00.024/x265_r4_0_0_024.7z
%Extract-->% .\x265_r4_0_0_024.7z > nul
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

:: Download embedded Python ~3.12.7
%Download-->% https://www.python.org/ftp/python/3.12.7/python-3.12.7-embed-amd64.zip
%Tar-->% -xf .\python-3.12.7-embed-amd64.zip
del .\python-3.12.7-embed-amd64.zip

:: Download VapourSynth64 Portable ~R70
%Download-->% https://github.com/vapoursynth/vapoursynth/releases/download/R70/VapourSynth64-Portable-R70.zip
%Tar-->% -xf .\VapourSynth64-Portable-R70.zip > nul
del .\VapourSynth64-Portable-R70.zip

:: install pip
echo import site >> python312._pth
%Download-->% https://bootstrap.pypa.io/get-pip.py
.\python.exe get-pip.py --no-warn-script-location > nul

:: install VapourSynth64 wheel
.\Scripts\pip.exe install .\wheel\VapourSynth-70-cp312-cp312-win_amd64.whl --no-warn-script-location  > nul

:: Download plugins
 .\python.exe .\vsrepo.py update -p  > nul
 .\python.exe .\vsrepo.py install lsmas ffms2 bestsource -p

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

:: Download SVT-AV1-PSY release ~2.3.0
%Download-->% https://github.com/user-attachments/files/17579354/SvtAv1EncApp-windows-all-march-but-znver3.zip
%Tar-->% -xf .\SvtAv1EncApp-windows-all-march-but-znver3.zip SvtAv1EncApp-windows-all-march-but-znver3.7z > nul
%AV1%\7zr.exe -y e .\SvtAv1EncApp-windows-all-march-but-znver3.7z x86-64\SvtAv1EncApp.exe > nul

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
