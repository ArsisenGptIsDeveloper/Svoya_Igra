@echo off
setlocal

cd /d "%~dp0"

echo [1/3] Updating repository...
git pull --ff-only
if errorlevel 1 (
  echo [WARN] git pull failed. Continuing with current local files.
)

echo [2/3] Opening app in browser...
start "" "http://localhost:4173/svoya_igra_with_public_key_editor_fixed2.html"

echo [3/3] Starting local server on port 4173...
where py >nul 2>&1
if %errorlevel%==0 (
  py -m http.server 4173
  goto :eof
)

where python >nul 2>&1
if %errorlevel%==0 (
  python -m http.server 4173
  goto :eof
)

echo [ERROR] Python not found. Install Python 3 and try again.
pause
