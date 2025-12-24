#!/bin/bash

# 1. Get the title
# If you provided arguments (e.g. post My Title), use them.
# If not, ask for input.
if [ -n "$1" ]; then
    title="$*"
else
    echo "Enter post title: "
    read title
fi

# 2. Get current date and time
date_str=$(date +%Y-%m-%d)
time_str=$(date "+%Y-%m-%d %H:%M:%S %z")

# 3. Convert title to slug (lowercase, special chars to hyphens)
slug=$(echo "$title" | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z | sed 's/^-//;s/-$//')

# 4. Create filename
filename="_posts/${date_str}-${slug}.md"

# 5. Create file with content
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

echo "Created $filename"

# 6. Open in VS Code
code "$filename"