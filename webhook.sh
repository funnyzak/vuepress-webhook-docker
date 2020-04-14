#!/bin/sh

cd /app/code

echo "git pull code start" 
git pull
echo "git pull code end"

echo "build start"
npm install && npm run build || (echo "Build failed. Aborting!"; exit 1)
echo "Build Done!"

echo "Copying files..."
rsync -q -r --delete .vuepress/dist/ /app/output/