del /q "%1\*"
for /D %%p in ("%1\*.*") do rmdir "%%p" /s /q

for /f "delims=" %%A in ("%1") do (
   set foldername=%%~nxA
)

set path = echo ("%cd")
cd "%1"
cd "..\"
set tempname = echo "graphlabs.temp.name"
rename ".\%foldername%" "%tempname%"

npx create-react-app %foldername% --typescript
npm i graphlabs.core.template
npm i --save-dev tslint tslint-react tslint-config-prettier
# To be removed
npm i --save-dev es6-promise redux-devtools-extension

copy "%path%\sources\init-project\.editorconfig" ".\%tempname%\.editorconfig"
copy "%path\sources\init-project\tslint.json .\%tempname%\tslint.json"
copy "%path\sources\init-project\tsconfig.json" ".\%tempname%\tsconfig.json"
copy "%path\sources\init-project\App.tsx" ".\%tempname%\src\App.tsx"

echo -e "//tslint:disable\n$(cat .\%tempname%\src\service-worker.ts)" >> ".\%tempname%\src\service-worker.ts"
echo -e ".idea\n$(cat .\%tempname%\.gitignore)" >> ".\%tempname%\.gitignore"

set tempfile = ".\%tempname%\package.tmp"
set inputfile = ".\%tempname%\package.json"
copy /y nul %tempfile%

for /F "eol= delims=" %l in (%inputfile%) do (
    if %%l == "\"scripts\": {" (
        echo %%l && "\n" && "lint\": \"tslint --fix --project .\"" >> %tempfile%
    )
    else (echo %%l >> %tempfile%)
)

del /q "%inputfile%"
move "%tempfile%" "%inputfile%"

rename ".\%tempname%" "%foldername%"

cd "%path%"