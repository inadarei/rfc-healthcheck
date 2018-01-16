#!/bin/sh

# link pre-commit from .git/hooks to here so every checkout has it
gitpath=`git rev-parse --git-dir`
projectpath="$(dirname $gitpath)/"
if test "$projectpath" = './'; then
  projectpath="$(pwd)/"
fi
ln -s -f "$projectpath.githooks/pre-push" "$gitpath/hooks/pre-push"
