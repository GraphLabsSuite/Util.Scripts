del /q "%1\*"
for /D %%p in ("%1\*.*") do rmdir "%%p" /s /q

for /f "delims=" %%A in ("%1") do (
   set foldername=%%~nxA
)

set path = echo ("%cd")
cd "%1"

rename . test

npx create-react-app $1 --typescript
npm i graphlabs.core.template
npm i --save-dev tslint tslint-react tslint-config-prettier
# To be removed
npm i --save-dev es6-promise redux-devtools-extension

copy "%path%\sources\init-project\.editorconfig" ".\.editorconfig"
copy "%path\sources\init-project\tslint.json .\tslint.json"
copy "%path\sources\init-project\tsconfig.json" ".\tsconfig.json"
copy "%path\sources\init-project\App.tsx" ".\src/App.tsx"

echo -e "//tslint:disable\n$(cat %1\src\service-worker.ts)" >> ".\src\service-worker.ts"
echo -e ".idea\n$(cat %1\.gitignore)" >> ".\.gitignore"

set tempfile = ".\package.tmp"
set inputfile = ".\package.json"
copy /y nul %tempfile%

for /F "eol= delims=" %l in (%inputfile%) do (
    if %%l == "\"scripts\": {" (
        echo %%l && "\n" && "lint\": \"tslint --fix --project .\"" >> %tempfile%
    )
    else (echo %%l >> %tempfile%)
)

del /q "%inputfile%"
move "%tempfile%" "%inputfile%"

rename . %foldername%

cd "%path%"