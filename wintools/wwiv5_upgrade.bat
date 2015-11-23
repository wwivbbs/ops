@Echo OFF

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "%1", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

@Echo OFF

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
GOTO RUNWWIV

:USAGE
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
ECHO.
set /p run_wwiv="Launch WWIV Now? Press 1 for YES | 2 for NO: "
ECHO.
if %run_wwiv% EQU 1 GOTO LAUNCHWWIV in NOT GOTO RUNWWIV
if %run_wwiv% EQU 2 GOTO CHANGES in NOT GOTO RUNWWIV

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
