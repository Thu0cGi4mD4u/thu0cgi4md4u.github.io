#!/bin/bash

# 1. Get the keyword (Combine all arguments into one string)
if [ -n "$1" ]; then
    keyword="$*"
else
    echo "Enter a keyword to find the post:"
    read keyword
fi

# 2. Convert input to "slug" format (e.g. "Đại Số" -> "dai-so")
# This helps find the file even if you type the title with accents/spaces
slug_keyword=$(echo "$keyword" | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z | sed 's/^-//;s/-$//')

echo "🔍 Searching for '$keyword' (or slug '$slug_keyword')..."

# 3. Search for files (Case insensitive, check both original and slug)
matches=$(find _posts -type f \( -iname "*$keyword*" -o -iname "*$slug_keyword*" \) | sort)

# Count results
count=$(echo "$matches" | grep -c ".md")

# 4. Logic handling
if [ -z "$matches" ] || [ "$count" -eq 0 ]; then
    echo "❌ No post found."
    exit 1

elif [ "$count" -eq 1 ]; then
    echo "Found: $matches"
    echo "⚠️  Are you sure you want to DELETE this file? (y/n)"
    read confirm
    if [ "$confirm" == "y" ]; then
        rm "$matches"
        echo "✅ Deleted: $matches"
    else
        echo "❌ Cancelled."
    fi

else
    echo "⚠️  Found $count posts matching your keywords:"
    echo "-----------------------------------"
    echo "$matches"
    echo "-----------------------------------"
    echo "❌ Please be more specific."
fi