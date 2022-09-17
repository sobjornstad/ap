#!/bin/bash

die() {
    ret=$?
    printf "%s\\n" "$@" >&2
    exit $ret
}

ap posts.ap || die "attopublish build failed."
git commit -am "update"

tmp_location="/tmp/build-ap"
pages_branch="gh-pages"

# Precondition check.
git diff-index --quiet HEAD || die "Working directory is dirty. Please commit changes before continuing."
[ -f "posts.ap" ] || die "Please run this script from the project root."
git rev-parse "$pages_branch" >/dev/null 2>/dev/null || die "The gh-pages branch does not exist."

revision=$(git rev-parse HEAD)
rm -rf "$tmp_location"

git worktree add "$tmp_location" "$pages_branch"
cp -r _build/* "$tmp_location"
(
    cd "$tmp_location" || die "Failed to cd to just-created temporary location!"
    git add .
    git commit -am "updating GitHub Pages branch with build from $revision"
)
rm -rf "$tmp_location"
git worktree prune
git push origin gh-pages
