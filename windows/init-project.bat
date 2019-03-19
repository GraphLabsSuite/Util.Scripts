del /q "%1\*"
for /D %%p in ("%1\*.*") do rmdir "%%p" /s /q

:: npx create-react-app $1 --typescript
:: npm i graphlabs.core.template
:: npm i --save-dev tslint tslint-react tslint-config-prettier
:: # To be removed
:: npm i --save-dev es6-promise redux-devtools-extension

cp "..\sources\init-project\.editorconfig" "%1\.editorconfig"
cp "../sources\init-project\tslint.json %1\tslint.json"
cp "..\sources\init-project\tsconfig.json" "%1\tsconfig.json"
cp "..\sources\init-project\App.tsx" "%1\src/App.tsx"

echo -e "//tslint:disable\n$(cat %1\src\service-worker.ts)" >> "%1\src\service-worker.ts"
echo -e ".idea\n$(cat %1\.gitignore)" >> "%1\.gitignore"

set tempfile = "%1\package.tmp"
set inputfile = "%1\package.json"

for /F "eol= delims=" %l in (%inputfile%) do (
    if %%l == "\"scripts\": {" (
        echo %%l && "\n" && "lint\": \"tslint --fix --project .\"" >> %tempfile%
    )
    else (echo %%l >> %tempfile%)
)

del /q "%inputfile%"
move "%tempfile%" "%inputfile%"