#!/bin/bash
#
# Initialize a clean Git repository for Kasimba
# This script cleans up any existing Git repository and creates a fresh one

echo "Initializing clean Git repository for Kasimba..."

# Remove existing Git repository if present
if [ -d ".git" ]; then
  echo "Removing existing Git repository..."
  rm -rf .git
fi

# Initialize new Git repository
git init

# Add all files to the repository
git add .

# Initial commit
git commit -m "Initial commit of Kasimba - Windows to SMB path converter for macOS"

echo "Git repository initialized successfully!"
echo ""
echo "Next steps:"
echo "1. Add a remote: git remote add origin <your-repository-url>"
echo "2. Push to remote: git push -u origin main" 