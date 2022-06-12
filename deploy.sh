#!/usr/bin/env sh

set -e

# build
yarn build --base=/vue-web-speech-api

# navigate into the build output directory
cd dist


git init
git checkout -b main
git add -A
git commit -m 'deploy'

git push -f git@github.com:mrchoke/vue-web-speech-api.git main:gh-pages

cd -
