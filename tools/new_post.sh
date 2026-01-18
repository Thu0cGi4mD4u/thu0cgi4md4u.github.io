#!/bin/bash

# --- SMART PATH DETECTION ---
# If we are in the root (and see a _posts folder), go inside it.
# If we are already inside _posts, just stay here.
if [ -d "_posts" ]; then
    base_dir="_posts"
else
    base_dir="."
fi
# -----------------------------

# 1. Get input
if [ -n "$1" ]; then
    input="$*"
else
    echo "Enter title (e.g. 'My Post' or 'math/My Post'): "
    read input
fi

# 2. Handle Subfolders
if [[ "$input" == *"/"* ]]; then
    subfolder="${input%%/*}"
    raw_title="${input#*/}"
    target_dir="${base_dir}/${subfolder}" # Use base_dir variable
    mkdir -p "$target_dir"
else
    raw_title="$input"
    target_dir="${base_dir}"              # Use base_dir variable
fi

# 3. Clean title and create filename
title=$(echo "$raw_title" | sed 's/^[ \t]*//;s/[ \t]*$//')
date_str=$(date +%Y-%m-%d)
time_str=$(date "+%Y-%m-%d %H:%M:%S %z")
slug=$(echo "$title" | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z | sed 's/^-//;s/-$//')
filename="${target_dir}/${date_str}-${slug}.md"

# 4. Create File
cat <<EOF > "$filename"
---
title: $title
date: $time_str
categories: [TOP_CATEGORY, SUB_CATEGORY]
tags: [tag1]
pin: false
math: true
mermaid: true
---

## Introduction

Write your content here...
EOF

echo "Created: $filename"
code "$filename"