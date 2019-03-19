#!/usr/bin/env bash

rm -r $1/*
npx create-react-app $1 --typescript
npm i graphlabs.core.template
npm i --save-dev tslint tslint-react tslint-config-prettier
# To be removed
npm i --save-dev es6-promise redux-devtools-extension

cp ../sources/init-project/.editorconfig $1/.editorconfig
cp ../sources/init-project/tslint.json $1/tslint.json
cp ../sources/init-project/tsconfig.json $1/tsconfig.json
cp ../sources/init-project/App.tsx $1/src/App.tsx

echo -e "//tslint:disable\n$(cat $1/src/service-worker.ts)" > $1/src/service-worker.ts
echo -e ".idea\n$(cat $1/.gitignore)" > $1/.gitignore
sed '/"scripts": {/ a "lint": "tslint --fix --project .",' $1/package.json
