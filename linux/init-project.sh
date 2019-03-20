#!/usr/bin/env bash

DIR=$1
echo "$DIR/*"
rm -rf "$DIR/*"
find "$DIR" -maxdepth 1 -type f -exec rm {} \;
echo $(ls $DIR)
FDN=$(basename "$1")
DN=$(dirname "$1")
NFDN="graphlabs.${FDN,,}"
mv "$DN/$FDN" "$DN/$NFDN"
npx create-react-app "$DN/$NFDN" --typescript
npm i graphlabs.core.template
npm i --save-dev tslint tslint-react tslint-config-prettier
# To be removed
npm i --save-dev es6-promise redux-devtools-extension

cp "../sources/init-project/.editorconfig" "$DN/$NFDN/.editorconfig"
cp "../sources/init-project/tslint.json" "$DN/$NFDN/tslint.json"
cp "../sources/init-project/tsconfig.json" "$DN/$NFDN/tsconfig.json"
cp "../sources/init-project/App.tsx" "$DN/$NFDN/src/App.tsx"

echo -e "//tslint:disable\n$(cat $DN/$NFDN/src/service-worker.ts)" > "$DN/$NFDN/src/service-worker.ts"
echo -e ".idea\n$(cat $DN/$NFDN/.gitignore)" > "$DN/$NFDN/.gitignore"
sed '/"scripts": {/ a "lint": "tslint --fix --project .",' "$DN/$NFDN/package.json"
mv "$DN/$NFDN" "$DN/$FDN"
find "$DN/$FDN" -exec chmod 755 {} \;
