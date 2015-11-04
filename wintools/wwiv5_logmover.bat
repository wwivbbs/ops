@ ECHO OFF
REM This will move all the log files to a timestamped file 
REM from \wwiv\ to \wwiv\logs\archive\.
REM
REM The list of files to manage is hardcoded to these files:
REM     * \wwiv\NETWORK.LOG
REM     * \wwiv\NETWORKB.LOG
REM     * \wwiv\NEWS.LOG
REM     * \wwiv\WWIVSYNC.LOG
REM     * \wwiv\##########NEWS.LOG
REM     * \wwiv\nets\wwivnet\news.log
REM For more information on WWIV Log files: 
REM https://github.com/wwivbbs/wwiv/wiki/logfiles
REM 
REM Files are Moved and renamed YYYYMMDD-HHMMSS_FILENAME.LOG, 
REM except ##########NEWS.LOG are just moved as-is.
REM 
REM New Files will be automatically generated when the 
REM process logs to them again.

REM Preparing Timestamp Information
set year=%date:~10,4%
set month=%date:~4,2%
set day=%date:~7,2%
set hour=%time:~0,2%
REM Replace leading space with zero
if ô%hour:~0,1%ö ==ö ö set hour=0%hour:~1,1%
set minute=%time:~3,2%
set seconds=%time:~6,2%
set timestamp=%year%%month%%day%-%hour%%minute%%seconds%

REM These are the assumed drive and folders. Modify as needed.
set wwivfolder=c:\wwiv
set logarchive=c:\wwiv\logs\archives



REM Check for logarchive Folder
if not exist %logarchive%\ mkdir %logarchive%

REM Move the wwivfolder logs
echo --- Checking %wwivfolder%\network.log  
if exist %wwivfolder%\network.log  move %wwivfolder%\network.log %logarchive%\%timestamp%_network.log

echo --- Checking %wwivfolder%\networkb.log
if exist %wwivfolder%\networkb.log move %wwivfolder%\networkb.log %logarchive%\%timestamp%_networkb.log

echo --- Checking %wwivfolder%\news.log 
if exist %wwivfolder%\news.log move %wwivfolder%\news.log %logarchive%\%timestamp%_news.log

echo --- Checking %wwivfolder%\wwivsync.log 
if exist %wwivfolder%\wwivsync.log move %wwivfolder%\wwivsync.log %logarchive%\%timestamp%_wwivsync.log
echo.

echo --- NOTE: Moving ##########News.log files 
move %wwivfolder%\*news.log %logarchive%
echo --- NOTE: Not found errors are ok on this command
echo.

REM check for the logarchive\nets\wwivnet folder
if not exist %logarchive%\nets\wwivnet mkdir %logarchive%\nets\wwivnet

REM Move the wwivfolder\nets\wwivnet logs
echo --- Checking %wwivfolder%\nets\wwivnet\news.log
if exist %wwivfolder%\nets\wwivnet\news.log move %wwivfolder%\nets\wwivnet\news.log %logarchive%\nets\wwivnet\%timestamp%_news.log

echo.
echo Not all files will be found. That's is probably fine. 
echo Files that were found will show "1 file(s) moved.".
