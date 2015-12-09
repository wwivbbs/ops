@ECHO OFF

:SWITCHES
IF [%1]==[] GOTO LAUNCH
IF [%1]==[?] GOTO USAGE
IF [%1]==[-?] GOTO USAGE
IF [%1]==[/?] GOTO USAGE

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

:LAUNCH 
SET olddir=%CD%
SET build=
GOTO START

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

REM This requires you have WGET You need the Binaries
REM and the dependencies which can be found here:
REM http://gnuwin32.sourceforge.net/packages/wget.htm

REM This requires you have 7-ZIP which can be found here:
REM http://www.7-zip.org/download.html
REM or modify to use your favorite compression utility.

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


:CHECK BUILD
IF [%build%] EQU [] (
SET autoget=1
) ELSE (
SET autoget=0
)
GOTO BACKUPWWIV

:BACKUPWWIV
REM BACKUP WWIV
SET backup_file=%USERPROFILE%\documents\%timestamp%_wwiv.zip
CD "%ProgramFiles%\7-Zip\"
7z.exe a -r -y %backup_file% C:\wwiv\*.*
GOTO FETCHWWIV

:FETCHWWIV
REM FETCH NEW WWIV UPDATE
CD %USERPROFILE%\downloads\

IF [%autoget%] EQU [1] (
REM FETCH LATEST BUILD AND PAtCH WWIV
MD wwiv-temp
CD wwiv-temp
"%WGETPATH%"\GnuWin32\bin\wget.exe -r -np -nd --accept zip,ZIP --reject=htm,html,php,asp,txt,md --timestamping -e robots=off http://build.wwivbbs.org/jenkins/job/wwiv/lastSuccessfulBuild/label=windows/artifact/
DEL /Q archive.zip
DIR /B wwiv-build-win*.zip > build_file.txt
FOR /f "tokens=* delims= " %%a IN (build_file.txt) DO (
SET FILENAME=%%a
)
TIMEOUT /T 1
"%PROGRAMFILES%\7-Zip\7z.exe" e -oc:\wwiv -y %FILENAME% *.exe
TIMEOUT /T 1
"%PROGRAMFILES%\7-Zip\7z.exe" e -oc:\wwiv -y %FILENAME% *.dll
TIMEOUT /T 1
"%PROGRAMFILES%\7-Zip\7z.exe" e -o%SYSTEMROOT%\system32 -y %FILENAME% *.dll
XCOPY wwiv-build-win*.* %USERPROFILE%\downloads\
DEL /Q *.*
CD ..
RD wwiv-temp
SET changes_url=http://build.wwivbbs.org/job/wwiv/lastSuccessfulBuild/label=windows/changes
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
SET changes_url=http://build.wwivbbs.org/jenkins/job/wwiv/%build%/changes
)
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
ECHO.
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
START %changes_url%
GOTO DONE

:ABORT
ECHO.
ECHO UPDATE ABORTED BY USER
GOTO DONE

:DONE
CD "%olddir%"
EXIT /B
