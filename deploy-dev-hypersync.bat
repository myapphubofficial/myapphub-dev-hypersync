@echo off
echo ==========================================
echo    Deploying HyperSync to Dev App
echo ==========================================

echo [1/4] Auto-incrementing version in update.json...
node -e "const fs=require('fs'); const file='./update.json'; const pkg=JSON.parse(fs.readFileSync(file)); const parts=pkg.version.split('.'); parts[2]=parseInt(parts[2])+1; pkg.version=parts.join('.'); fs.writeFileSync(file, JSON.stringify(pkg, null, 2)); console.log('Version updated to '+pkg.version);"

echo [2/4] Building Vite app...
cd ..\..\myapphub-dev
call npm run build
if %errorlevel% neq 0 (
    echo Build failed!
    pause
    exit /b %errorlevel%
)

echo [3/4] Zipping dist folder...
cd dist
tar.exe -a -c -f ..\..\Hypersync\myapphub-dev-hypersync\update.zip *
if %errorlevel% neq 0 (
    echo Zipping failed!
    pause
    exit /b %errorlevel%
)

cd ..\..\Hypersync\myapphub-dev-hypersync
echo [4/4] Pushing to GitHub...
git add update.zip update.json
git commit -m "HyperSync Auto Update"
git push origin main

echo ==========================================
echo    HyperSync Update Deployed Successfully!
echo ==========================================
pause
