#!/bin/sh
set -e

fail() { echo "[1;31mError:[m $1"; exit 1; }

CUR_STATUS="$(git status --porcelain)"
[ -z "$CUR_STATUS" ] || fail "Working directory is dirty."

CUR_BRANCH="$(git symbolic-ref -q HEAD)"
[ "$CUR_BRANCH" = refs/heads/master ] ||
fail "Current branch is not master"

CUR_COMMIT="$(git rev-parse -q --verify HEAD)"
DOC_BRANCH=gh-pages
git show-ref -q --verify "refs/heads/$DOC_BRANCH" &&
git branch -qD "$DOC_BRANCH"
git checkout -q --orphan "$DOC_BRANCH"
git rm -qrf .
git clean -qfxde/target
mv target/doc/* .
rm -r target
git add .
git commit -qm"$CUR_COMMIT"
git checkout -q master
