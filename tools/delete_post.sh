#!/bin/bash

# --- SMART PATH DETECTION ---
if [ -d "_posts" ]; then
    search_dir="_posts"
else
    search_dir="."
fi
# -----------------------------

if [ -n "$1" ]; then
    keyword="$*"
else
    echo "Enter a keyword to find the post:"
    read keyword
fi

slug_keyword=$(echo "$keyword" | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z | sed 's/^-//;s/-$//')

echo "🔍 Searching in '$search_dir'..."

# Find files in the detected directory
matches=$(find "$search_dir" -type f \( -iname "*$keyword*" -o -iname "*$slug_keyword*" \) | sort)

count=$(echo "$matches" | grep -c ".md")

if [ -z "$matches" ] || [ "$count" -eq 0 ]; then
    echo "❌ No post found."
    exit 1
elif [ "$count" -eq 1 ]; then
    echo "Found: $matches"
    echo "⚠️  Delete this file? (y/n)"
    read confirm
    if [ "$confirm" == "y" ]; then
        rm "$matches"
        echo "✅ Deleted."
    else
        echo "❌ Cancelled."
    fi
else
    echo "⚠️  Found $count posts:"
    echo "$matches"
    echo "❌ Please be more specific."
fi