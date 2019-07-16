---
title: "Hook to automatically add issue number during 'git commit'"
---

Save as `.git/hooks/commit-msg`:

```
#!/bin/bash

COMMIT_MSG_FILE="$1"
BRANCH_NAME=$(git symbolic-ref --short HEAD)

# check if branch name is following to the "issue-123-xxxx" format
if [[ ${BRANCH_NAME%%-*} != "issue" ]]
then
    exit 0
fi

ISSUE_STRING=${BRANCH_NAME#issue-}
ISSUE_STRING=${ISSUE_STRING%%-*}
ISSUE_STRING="Issue: #$ISSUE_STRING"

# add issue number only if not already added
if [[ $(grep -c "$ISSUE_STRING" $COMMIT_MSG_FILE) -eq 0 ]]
then
    # add issue number depends on how 'git commit' was called:
    #   - 'git commit' => before the first line started with the '#'
    #   - 'git commit -m "xxx"' => after the last line
    gawk -i inplace -v "var=$ISSUE_STRING" \
        '/^#.*/ && !x {printf("\n"); print var; x=1} ENDFILE {if (!x) {printf("\n"); print var}} 1' \
        $COMMIT_MSG_FILE
fi
```