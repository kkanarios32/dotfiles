#!/bin/bash 

git pull origin master --rebase
git submodule update --remote --merge 
git add . 
git commit -am "update"
git push origin master
