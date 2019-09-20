#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo -t maupassant # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public
# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back up to the Project Root
cd ..

# Add changes to git.
git add .

# Commit changes.
msg2="add new content of site `date`"
if [ $# -eq 1 ]
  then msg2="$1"
fi
git commit -m "$msg2"

# Push source and build repos.
git push origin master