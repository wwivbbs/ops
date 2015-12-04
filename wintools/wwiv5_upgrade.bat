<<<<<<< HEAD
@Echo OFF
=======
@ECHO OFF
>>>>>>> 1ceffbd4371410928255d8705da8912a1fee9a86

:SWITCHES
IF [%1]==[] GOTO START
IF [%1]==[?] GOTO USAGE
IF [%1]==[-?] GOTO USAGE
IF [%1]==[/?] GOTO USAGE

:LAUNCH 
SET olddir=%CD%

:GETADMIN
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
IF '%errorlevel%' NEQ '0' (
    ECHO Requesting administrative privileges...
    GOTO UACPrompt
) ELSE ( goto gotAdmin )

:UACPrompt
    ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    ECHO UAC.ShellExecute "%~s0", "%1", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    EXIT /B

:gotAdmin
    IF exist "%temp%\getadmin.vbs" ( DEL "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

:START
@ECHO OFF
REM CREATE UNIQUE FILE NAME FOR BACKUP
SET local 
SET year=%DATE:~-4,4% 
SET month=%DATE:~-7,2% 
SET day=%DATE:~-10,2% 
SET hour=%TIME:~0,2% 
REM REMOVE HOUR LEADING ZEROS 
IF '%hour:~0,1%' == ' ' set hour=0%hour:~1,1% 
SET minute=%time:~3,2% 
SET seconds=%time:~6,2% 
SET timestamp=%year%%month%%day%%hour%%minute%%seconds%
REM TRIM OUT SPACES
SET timestamp=%timestamp: =%

:LAUNCH 
set olddir=%CD%
goto START

:START
REM CREATE UNIQUE FILE NAME FOR BACKUP
set local 
set year=%DATE:~-4,4% 
set month=%DATE:~-7,2% 
set day=%DATE:~-10,2% 
set hour=%TIME:~0,2% 
REM REMOVE HOUR LEADING ZEROS 
if '%hour:~0,1%' == ' ' set hour=0%hour:~1,1% 
set minute=%time:~3,2% 
set seconds=%time:~6,2% 
set timestamp=%year%%month%%day%%hour%%minute%%seconds%
REM TRIM OUT SPACES
set timestamp=%timestamp: =%

REM This requires you have WGET You need the Binaries
REM and the dependencies which can be found here:
REM http://gnuwin32.sourceforge.net/packages/wget.htm

REM This requires you have 7-ZIP which can be found here:
REM http://www.7-zip.org/download.html
REM or modify to use your favorite compression utility.

<<<<<<< HEAD
IF [%1]==[] GOTO INPUTS
IF [%1]==[?] GOTO USAGE
IF [%1]==[-?] GOTO USAGE
IF [%1]==[/?] GOTO USAGE

:INPUTS
cls
ECHO.
ECHO *** MAKE SURE WWIV AND TELNET SERVER ARE CLOSED BEFORE PROCEEDING ***
ECHO.
ECHO.
ECHO ENTER BUILD NUMBER FOR UPDATE
ECHO.
set /p build=Enter Build Number: 

if %build% EQU '' GOTO INPUTS if NOT GOTO TOOL

:TOOL
cls
ECHO.
ECHO Select A COMPRESSION TOOL:
ECHO ==========================
ECHO.
ECHO 1) 7-Zip
ECHO 2) WinRAR
ECHO 3) ABORT UDATE
ECHO.
set /p input=Select Option: 

if %input% EQU 1 GOTO 7ZIP if NOT GOTO TOOL
if %input% EQU 2 GOTO WINRAR if NOT GOTO TOOL
if %input% EQU 3 GOTO ABORT if NOT GOTO TOOL
if %input% GTR 3 GOTO TOOL

:7ZIP
REM BACKUP WWIV
set backup_file1=%USERPROFILE%\documents\%timestamp%_wwiv.zip
cd "%ProgramFiles%\7-Zip\"
7z.exe a -r -y %backup_file1% C:\wwiv\*.*
REM FETCH NEW WWIV UPDATE
set build_file=http://build.wwivbbs.org/job/WWIV/%build%/label=windows/artifact/wwiv-build-win-%build%.zip
cd %USERPROFILE%\downloads\
"%ProgramFiles(x86)%\GnuWin32\bin\wget.exe" %build_file%
REM EXTRACT FILES FOR UPDATE
"%ProgramFiles%\7-Zip\7z.exe" e -oc:\wwiv -y wwiv-build-win-%build%.zip *.exe
"%ProgramFiles%\7-Zip\7z.exe" e -oc:\wwiv -y wwiv-build-win-%build%.zip *.dll
"%ProgramFiles%\7-Zip\7z.exe" e -o%SystemRoot%\system32 -y wwiv-build-win-%build%.zip *.dll
ECHO.
ECHO WWIV UDATE COMPLETE!
PAUSE
GOTO RUNWWIV

:WINRAR
REM BACKUP WWIV
set backup_file2=%USERPROFILE%\documents\%timestamp%_wwiv.rar
cd "%ProgramFiles%\WinRAR\"
Rar.exe a -r %backup_file2% C:\wwiv\*.*
REM FETCH NEW WWIV UPDATE
set build_file=http://build.wwivbbs.org/job/WWIV/%build%/label=windows/artifact/wwiv-build-win-%build%.zip
cd %USERPROFILE%\downloads\
"%ProgramFiles(x86)%\GnuWin32\bin\wget.exe" %build_file%
REM EXTRACT FILES FOR UPDATE
"%ProgramFiles%\WinRAR\WinRAR.exe" e -y wwiv-build-win-%build%.zip *.exe C:\wwiv
"%ProgramFiles%\WinRAR\WinRAR.exe" e -y wwiv-build-win-%build%.zip *.dll C:\wwiv
"%ProgramFiles%\WinRAR\WinRAR.exe" e -y wwiv-build-win-%build%.zip *.dll %SystemRoot%\system32
ECHO.
ECHO WWIV UDATE COMPLETE!
PAUSE
=======
:CHECKAPPS
REM CONFIRM WGET EXISTS
CLS

:WGET64
IF EXIST "%PROGRAMFILES(x86)%\GnuWin32\bin\wget.exe" (GOTO CHECK7Z) ELSE (GOTO WGET32)

:WGET32
IF EXIST "%PROGRAMFILES%\GnuWin32\bin\wget.exe" (
GOTO CHECK7Z
) ELSE (
ECHO THIS PROGRAM REQUIRES WGET
ECHO http://gnuwin32.sourceforge.net/packages/wget.htm
ECHO.
GOTO DONE
)

:CHECK7Z
IF EXIST "%PROGRAMFILES%\7-Zip\7z.exe" (
GOTO CHECKOS
) ELSE (
ECHO THIS PROGRAM REQUIRES Z-Zip
ECHO http://www.7-zip.org/download.html
ECHO.
GOTO DONE
)

:CHECKOS
REM Check 64bit or 32bit OS
IF EXIST "%PROGRAMFILES(X86)%" (GOTO 64BIT) ELSE (GOTO 32BIT)

:64BIT
SET wgetpath=%PROGRAMFILES(x86)%
GOTO INPUTS

:32BIT
SET wgetpath=%PROGRAMFILES%
GOTO INPUTS

:INPUTS
CLS
ECHO.
ECHO *** MAKE SURE WWIV AND TELNET SERVER ARE CLOSED BEFORE PROCEEDING ***
ECHO.
ECHO.
ECHO ENTER BUILD NUMBER FOR UPDATE OR PRESS ENTER FOR LATEST BUILD CAPTURE
ECHO.
SET /p build=Enter Build Number: 

IF %build% EQU '' (
SET autoget=1
GOTO TOOL
) ELSE (
SET autoget=0
GOTO BACKUPWWIV
)

:BACKUPWWIV
REM BACKUP WWIV
SET backup_file1=%USERPROFILE%\documents\%timestamp%_wwiv.zip
CD "%ProgramFiles%\7-Zip\"
7z.exe a -r -y %backup_file1% C:\wwiv\*.*
GOTO FETCHWWIV

:FETCHWWIV
REM FETCH NEW WWIV UPDATE
CD %USERPROFILE%\downloads\

IF %autoget% EQU [1] (
REM FETCH LATEST BUILD AND PAtCH WWIV
"%WGETPATH%"\GnuWin32\bin\wget.exe -r -np -nd --accept zip,ZIP --reject=htm,html,php,asp,txt,md --timestamping -e robots=off http://build.wwivbbs.org/job/wwiv/lastSuccessfulBuild/label=windows/artifact/
DEL /Q archive.zip
DIR /B wwiv-build-win*.zip > build_file.txt
FOR /f "tokens=* delims= " %%a IN (build_file.txt) DO (
SET FILENAME1=%%a
)
TIMEOUT /T 1
"%PROGRAMFILES%\7-Zip\7z.exe" e -oc:\wwiv -y %FILENAME1% *.exe
TIMEOUT /T 1
"%PROGRAMFILES%\7-Zip\7z.exe" e -oc:\wwiv -y %FILENAME1% *.dll
TIMEOUT /T 1
"%PROGRAMFILES%\7-Zip\7z.exe" e -o%SYSTEMROOT%\system32 -y %FILENAME1% *.dll
DEL /Q build_file.txt
) ELSE (
SET build_file=http://build.wwivbbs.org/job/WWIV/%build%/label=windows/artifact/wwiv-build-win-%build%.zip
"%wgetpath%"\GnuWin32\bin\wget.exe %build_file%
REM EXTRACT FILES FOR UPDATE
TIMEOUT /T 1
"%PROGRAMFILES%\7-Zip\7z.exe" e -oc:\wwiv -y wwiv-build-win-%build%.zip *.exe
TIMEOUT /T 1
"%PROGRAMFILES%\7-Zip\7z.exe" e -oc:\wwiv -y wwiv-build-win-%build%.zip *.dll
TIMEOUT /T 1
"%PROGRAMFILES%\7-Zip\7z.exe" e -o%SystemRoot%\system32 -y wwiv-build-win-%build%.zip *.dll
)
>>>>>>> 1ceffbd4371410928255d8705da8912a1fee9a86
GOTO RUNWWIV

:USAGE
CLS
ECHO How to Use WWIV 5.0 build to build wwiv5_upgrade.bat
ECHO.
ECHO     SYNTAX: wwiv5_upgrade.bat
ECHO.
ECHO     Paths and files names are based on your environment
ECHO     Requires WGET and 7-Zip. Links in the Comments.
ECHO.
ECHO     Backup will be placed here: 
ECHO         %USERPROFILE%\documents\timestamp_wwiv.zip
ECHO     New Build is expects to be found here: 
ECHO         http://build.wwivbbs.org/job/WWIV/####/label=windows
ECHO              /artifact/wwiv-build-win-####.zip

:RUNWWIV
CLS
ECHO.
ECHO PLEASE CHOOSE AN OPTION
ECHO.
ECHO 1) Launch WWIV with WWIVNet
ECHO 2) Launch WWIV Only
ECHO 3) Launch Nothing and Exit
ECHO.
set /p run_wwiv="Select Option: "
ECHO.
IF [%run_wwiv%] EQU [1] GOTO LAUNCHWWIVNET IF NOT GOTO RUNWWIV
IF [%run_wwiv%] EQU [2] GOTO LAUNCHWWIV IF NOT GOTO RUNWWIV
IF [%run_wwiv%] EQU [3] GOTO CHANGES IF NOT GOTO RUNWWIV

:LAUNCHWWIVNET
CD \wwiv
START /MIN C:\wwiv\WWIV5TelnetServer.exe
TIMEOUT /T 2
START C:\wwiv\bbs.exe -N1 -M
TIMEOUT /T 2
START /MIN C:\wwiv\binkp.cmd
GOTO CHANGES

:LAUNCHWWIV
CD \wwiv
START /MIN C:\wwiv\WWIV5TelnetServer.exe
TIMEOUT /T 2
C:\wwiv\bbs.exe -N1 -M
GOTO CHANGES

:CHANGES
START http://build.wwivbbs.org/job/wwiv/lastSuccessfulBuild/label=windows/changes
GOTO DONE

:ABORT
ECHO.
ECHO UPDATE ABORTED BY USER
GOTO DONE

:RUNWWIV
CLS
ECHO.
ECHO PLEASE CHOOSE AN OPTION
ECHO.
ECHO 1) Launch WWIV with WWIVNet
ECHO 2) Launch WWIV Only
ECHO 3) Launch Nothing and Exit
ECHO.
set /p run_wwiv="Select Option: "
ECHO.
if %run_wwiv% EQU 1 GOTO LAUNCHWWIVNET if NOT GOTO RUNWWIV
if %run_wwiv% EQU 2 GOTO LAUNCHWWIV if NOT GOTO RUNWWIV
if %run_wwiv% EQU 3 GOTO CHANGES if NOT GOTO RUNWWIV

:LAUNCHWWIVNET
START C:\wwiv\WWIV5TelnetServer.exe
START C:\wwiv\binkp.cmd
START C:\wwiv\wwiv.exe
GOTO CHANGES

:LAUNCHWWIV
START C:\wwiv\WWIV5TelnetServer.exe
GOTO CHANGES

:CHANGES
START http://build.wwivbbs.org/job/WWIV/%build%/changes
GOTO DONE

:ABORT
ECHO.
ECHO UPDATE ABORTED BY USER
GOTO DONE

:DONE
cd "%olddir%"
ECHO.
TIMEOUT /T 30
EXIT /B
