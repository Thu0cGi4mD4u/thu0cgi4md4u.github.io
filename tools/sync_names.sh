#!/bin/bash

# --- SMART PATH DETECTION ---
if [ -d "_posts" ]; then
    search_dir="_posts"
else
    search_dir="."
fi

echo "🔄 Checking filenames in '$search_dir'..."

# Find all .md files inside _posts (recursive)
find "$search_dir" -type f -name "*.md" | while read filepath; do

    # 1. Get the directory and current filename
    dir=$(dirname "$filepath")
    filename=$(basename "$filepath")

    # 2. Extract the Date (first 10 chars: YYYY-MM-DD)
    # We assume the file starts with the date.
    date_part="${filename:0:10}"

    # Check if it actually looks like a date (e.g. starts with 20..)
    if [[ ! "$date_part" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        # Skip files that don't start with a date (like README)
        continue
    fi

    # 3. Read the Title from the file content
    # Look for line starting with "title:", remove quotes, remove spaces
    title=$(grep "^title:" "$filepath" | head -1 | sed 's/^title:[ \t]*//' | sed 's/^"//;s/"$//' | sed "s/^'//;s/'$//")

    if [ -z "$title" ]; then
        continue
    fi

    # 4. Convert Title to Slug
    new_slug=$(echo "$title" | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z | sed 's/^-//;s/-$//')

    # 5. Construct the New Filename
    new_filename="${date_part}-${new_slug}.md"

    # 6. Compare and Rename
    if [ "$filename" != "$new_filename" ]; then
        echo "✏️  Renaming:"
        echo "   From: $filename"
        echo "   To:   $new_filename"
        mv "$filepath" "$dir/$new_filename"
    fi

done

echo "✅ Done syncing filenames!"