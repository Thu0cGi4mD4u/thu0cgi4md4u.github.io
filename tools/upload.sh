#!/bin/bash

# 1. Get the commit message
# If you provided arguments (e.g. upload fixed typo), use them.
# If not, ask for input.
if [ -n "$1" ]; then
    msg="$*"
else
    echo "Enter commit message: "
    read msg
fi

# 2. Run the Git commands
echo "Adding files..."
git add .

echo "Committing with message: '$msg'..."
git commit -m "$msg"

echo "Pushing to GitHub..."
git push

echo "Done! ✅"