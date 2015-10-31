@Echo Off

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

REM This requires you have WGET You need the Binaries
REM and the dependencies which can be found here:
REM http://gnuwin32.sourceforge.net/packages/wget.htm

REM This requires you have 7ZIP which can be found here:
REM http://www.7-zip.org/download.html
REM or modify to use your favorite compression utility.


IF [%1]==[] GOTO USAGE
IF [%1]==[?] GOTO USAGE
IF [%1]==[-?] GOTO USAGE
IF [%1]==[/?] GOTO USAGE

:BEGIN
set local
REM Preparing Timestamp Information
set year=%date:~10,4%
set month=%date:~4,2%
set day=%date:~7,2%
set hour=%time:~0,2%
REM Replace leading space with zero
if “%hour:~0,1%” ==” ” set hour=0%hour:~1,1%
set minute=%time:~3,2%
set seconds=%time:~6,2%
set timestamp=%year%%month%%day%%hour%%minute%%seconds%
set backup_file=%userprofile%\documents\%timestamp%_wwiv.zip

REM BAckup the current running version 
c:
cd \

7z a -r %backup_file% c:\wwiv\*.*

REM GET the New Build and upgrade the install
c:
cd %userprofile%\downloads\
c:\tools\wget http://build.wwivbbs.org/job/WWIV/label=windows/%1/artifact/wwiv-build-win-%1.zip
7z e -oc:\wwiv -y wwiv-build-win-%1.zip *.exe
7z e -oc:\wwiv -y wwiv-build-win-%1.zip *.dll
7z e -o%SystemRoot%\system32 -y wwiv-build-win-%1.zip *.dll
GOTO DONE

:USAGE
ECHO How to Use WWIV 5.0 build to build wwiv5_upgrade.bat
ECHO.
ECHO     SYNTAX: wwiv5_upgrade.bat ####
ECHO         ### is a build number
ECHO.
ECHO     Paths and files names are based on your environment
ECHO     Requires WGET and 7Zip. Links in the Comments.
ECHO.
ECHO     Backup will be placed here: 
ECHO         %userprofile%\documents\timestamp_wwiv.zip
ECHO     New Build is expects to be found here: 
ECHO         http://build.wwivbbs.org/job/WWIV/label=windows
ECHO              /####/artifact/wwiv-build-win-####.zip
ECHO.
GOTO DONE

:DONE
pause