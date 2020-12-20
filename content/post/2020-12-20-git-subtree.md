---
title: "Tracking external dependencies with git-subtree"
---

git-subtree(1) provides a nice way to integrate external code and track it over time.
For example to add the source code of [Hugo](https://github.com/gohugoio/hugo) under the sub-directory *'hugo'*:

    $ git subtree add -P hugo git@github.com:gohugoio/hugo.git v0.79.1 --squash --message="import hugo v0.79.1"

The man-page of git-subtree provides an explanation of available commands.