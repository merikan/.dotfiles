#!/bin/sh
#
# Rewrite all branches to modify the date of one specific commit in a repo.
#
# Sample date format: Fri Jan 2 21:38:53 2009 -0800
# ISO8601 and RFC822 dates will also work.
#
# Note: filter-branch is picky about the commit argument. As of 1.7.0.4,
# a hex ID will work, the symbolic revision HEAD will fail silently,
# and the usability of more exotic rev specs was not tested by the author.
#
# Copyright (c) Eric S. Raymond, 2010-08-01. BSD terms apply (if anybody really thinks that this
# script is long and non-obvious enough to fall under copyright law).
#
commit="$1"
date="$2"
git filter-branch --env-filter \
    "if test \$GIT_COMMIT = '$commit'
     then
         export GIT_AUTHOR_DATE
         export GIT_COMMITTER_DATE
         GIT_AUTHOR_DATE='$date'
         GIT_COMMITTER_DATE='$date'
     fi" &&
rm -fr "$(git rev-parse --git-dir)/refs/original/"
