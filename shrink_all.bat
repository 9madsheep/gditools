@echo off
mode con:cols=100 lines=40
Title GDI Shrinking
rem "C:\Python27" can be changed if python is installed in other location
rem this fixes path variable that have Python 3.x.x path first. 
SET PATH="C:\Python27";%PATH%
cls
echo Press ctrl+c to cancel or any key to continue...
pause >nul

echo.
for /f "tokens=*" %%i in ('python --version  2^>^&1^') do set pyver=%%i
If "%pyver%"=="%pyver:Python=%" (set pyver=No Python found)
echo NOTE: Python 2.7.x is required to use gditools, Python 3.x.x will not work.
echo Your installed Python version is: %pyver%
pause >nul

echo.
echo NOTE: If you have the REDUMP game set, they add some non-standard track data to
echo their gdi files that may or may not work correctly. TOSEC or TruRip are preferred.
pause >nul

echo.
echo Instructions:
echo Make sure to copy this script as well as the gdishrink.py, gditools.py, and iso9660.py
echo files into your directory of Dreamcast game folders or it won't work. The folder must
echo contain sub-folders that each have one game's .gdi file and associated image files.
echo.
echo For example:
echo.
echo ÃÄÄ Crazy Taxi v1.004 (1999)(Sega)(NTSC)(US)[!][10S 51035]
echo ³   ÃÄÄ Crazy Taxi v1.004 (1999)(Sega)(NTSC)(US)[!][10S 51035].gdi
echo ³   ÃÄÄ track01.bin
echo ³   ÃÄÄ track02.raw
echo ³   ÀÄÄ track03.bin
echo ÃÄÄ Dead or Alive 2 v1.100 (2000)(Tecmo)(NTSC)(US)[!]
echo ³   ÃÄÄ Dead or Alive 2 v1.100 (2000)(Tecmo)(NTSC)(US)[!].gdi
echo ³   ÃÄÄ track01.bin
echo ³   ÃÄÄ track02.raw
echo ³   ÀÄÄ track03.bin
echo ÃÄÄ Rez v1.003 (2001)(Sega)(PAL)(M6)[!]
echo ³   ÃÄÄ Rez v1.003 (2001)(Sega)(PAL)(M6)[!].gdi
echo ³   ÃÄÄ track01.bin
echo ³   ÃÄÄ track02.raw
echo ³   ÀÄÄ track03.bin
echo ÃÄÄ gdishrink.py
echo ÃÄÄ gditools.py
echo ÃÄÄ iso9660.py
echo ÀÄÄ shrink_all.bat
echo. 

echo Are you sure you want to shrink all .gdi images IN PLACE in directory:
echo %CD% 
echo IMPORTANT: Make sure you have backups of the original files, as this process is not reversible.
pause >nul
echo.
:read
set numthreads=2
set /p numthreads=How many threads would you like to use (recommended 2 for HDDs and 10 for SSDs):
echo %numthreads%| findstr /r "^[1-9][0-9]*$">nul
if NOT %errorlevel% equ 0 (
    echo You must enter a valid number of threads
	goto read
)

echo Using %numthreads% threads

for /r %%a in (*.gdi) do call :loop "%%a"
:wait
call :checkinstances
if %INSTANCES% LSS 1 (
    echo Done!
	pause
    goto :eof
)
timeout /t 1 /nobreak >nul
goto wait

:loop
call :checkinstances
if %INSTANCES% LSS %numthreads% (
    echo Shinking "%~nx1"
    start /MIN python ./gdishrink.py %1
    goto :eof
)
timeout /t 1 /nobreak >nul
goto loop

:checkinstances
rem this could probably be done better. But INSTANCES should contain the number of running instances afterwards.
set cmdcount="wmic process where name="python.exe" 2>nul | find "python.exe" /c /i"
for /f "tokens=*" %%t in ('%cmdcount%') do set INSTANCES=%%t
goto :eof