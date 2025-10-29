@echo off
setlocal

REM === Config (change if needed) ===
set "REPORT_TEMPLATE=all"
set "MIN_SEVERITY=informational"
set "APPSCAN_CMD=appscancmd.exe"

REM === Paths ===
set "HERE=%~dp0"
set "PDF_DIR=%HERE%PDF"
set "XML_DIR=%HERE%XML"
set "SCAN_DONE_DIR=%HERE%Scan"

REM === Ensure output folders exist ===
if not exist "%PDF_DIR%" mkdir "%PDF_DIR%"
if not exist "%XML_DIR%" mkdir "%XML_DIR%"
if not exist "%SCAN_DONE_DIR%" mkdir "%SCAN_DONE_DIR%"

REM === Find appscancmd ===
where "%APPSCAN_CMD%" >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Cannot find appscancmd.exe. Add it to PATH or set APPSCAN_CMD to full path.
  exit /b 1
)

REM === Process all .scan files in this folder ===
set "foundAny="
for %%F in ("%HERE%*.scan") do (
  if exist "%%~fF" (
    set "foundAny=1"
    call :GEN_REPORT "%%~fF"
  )
)

if not defined foundAny (
  echo [INFO] No .scan files found in "%HERE%".
)

echo Done.
exit /b 0


:GEN_REPORT
setlocal
set "SCAN_FILE=%~1"
set "BASENAME=%~n1"
set "OUT_PDF=%PDF_DIR%\%BASENAME%-%REPORT_TEMPLATE%.pdf"
set "OUT_XML=%XML_DIR%\%BASENAME%-%REPORT_TEMPLATE%.xml"

echo ==========================================================
echo Generating reports for: "%SCAN_FILE%"
echo   Template     : %REPORT_TEMPLATE%
echo   Min severity : %MIN_SEVERITY%
echo   PDF  -> "%OUT_PDF%"
echo   XML  -> "%OUT_XML%"
echo ----------------------------------------------------------

set "OKPDF=0"
set "OKXML=0"

REM --- PDF report ---
"%APPSCAN_CMD%" report ^
  /base_scan "%SCAN_FILE%" ^
  /report_file "%OUT_PDF%" ^
  /report_type pdf ^
  /report_template "%REPORT_TEMPLATE%" ^
  /min_severity "%MIN_SEVERITY%" ^
  /v
if errorlevel 1 (
  echo [WARN] PDF report failed for "%SCAN_FILE%"
) else (
  set "OKPDF=1"
  echo [OK] PDF report created: "%OUT_PDF%"
)

REM --- XML report ---
"%APPSCAN_CMD%" report ^
  /base_scan "%SCAN_FILE%" ^
  /report_file "%OUT_XML%" ^
  /report_type xml ^
  /report_template "%REPORT_TEMPLATE%" ^
  /min_severity "%MIN_SEVERITY%" ^
  /v
if errorlevel 1 (
  echo [WARN] XML report failed for "%SCAN_FILE%"
) else (
  set "OKXML=1"
  echo [OK] XML report created: "%OUT_XML%"
)

REM --- Move .scan only if both reports succeeded ---
if "%OKPDF%"=="1" if "%OKXML%"=="1" (
  move /Y "%SCAN_FILE%" "%SCAN_DONE_DIR%\" >nul
  if errorlevel 1 (
    echo [WARN] Could not move "%SCAN_FILE%" to "%SCAN_DONE_DIR%"
  ) else (
    echo [OK] Moved scan file to: "%SCAN_DONE_DIR%"
  )
) else (
  echo [INFO] Not moving scan file because one or more reports failed.
)

endlocal & goto :eof
