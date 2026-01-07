#!/bin/bash

# Get current branch
branch=$(git branch --show-current)

# Add all changes
git add .

# Commit
git commit -m "Actualización de documentación y guías"

# Push
git push origin "$branch"
