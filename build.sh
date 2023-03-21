#!/bin/bash

die() {
    ret=$?
    printf "%s\\n" "$@" >&2
    exit $ret
}

tmp_location="/tmp/build-ap"
pages_branch="gh-pages"


echo "Sanity check..."
[ -f "posts.ap" ] || die "Please run this script from the project root."
git rev-parse "$pages_branch" >/dev/null 2>/dev/null || die "The gh-pages branch does not exist."
hash ap || die "ap not found on system path"


echo "Updating comments file..."
#echo "WARNING: Comment updates disabled as the email system is not available."
python3 /home/soren/cabinet/Me/Software/Active/attopublish/ap/comment_parser.py


echo "Rebuilding site..."
ap posts.ap || die "attopublish build failed."


echo "Committing changes..."
git add *.ap
git commit -am "update"
git diff-index --quiet HEAD || die "Working directory is still dirty after committing *.ap files. Please review and commit changes before continuing."


echo "Publishing site..."
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
