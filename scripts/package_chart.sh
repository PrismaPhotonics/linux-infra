#!/bin/bash
# publish-all-charts.sh
#
# This script packages all Helm charts found in a base directory (each chart in its own subdirectory),
# generates an index.yaml for them, and publishes the results to a GitHub Pages branch so that it
# can be used as a Helm repository.
#
# Usage:
#   ./publish-all-charts.sh [repo_root] [charts_base_directory] [gh-pages_branch] [repo_url]
#
# Defaults:
# - repo_root: .. (current directory)
# - charts_base_directory: charts
# - gh-pages_branch: gh-pages
# - repo_url: https://prismaphotonics.github.io/linux-infra/
#
# Requirements:
# - helm and git must be installed.
# - Your repository must be a git repo with a remote "origin".

set -e

# Assign default values if arguments are not provided.
REPO_ROOT="${1:-..}"
BASE_DIR="${2:-charts}"
GH_PAGES_BRANCH="${3:-gh-pages}"
REPO_URL="${4:-https://prismaphotonics.github.io/linux-infra/}"

# Change to repository root.
echo "Changing directory to repository root: $REPO_ROOT"
cd "$REPO_ROOT"

# Save current branch to switch back later, if it exists.
if git rev-parse HEAD >/dev/null 2>&1; then
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  echo "Current branch: $CURRENT_BRANCH"
else
  echo "No commits found in repository. This might be the first commit."
  CURRENT_BRANCH=""
fi

echo "Packaging charts from base directory: $BASE_DIR"

# Create a temporary directory for the packaged charts.
TMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TMP_DIR"

# Loop through each subdirectory in the base directory.
# Only package directories that contain a Chart.yaml file.
for chart in $(find "$BASE_DIR" -mindepth 1 -maxdepth 1 -type d); do
  if [ -f "$chart/Chart.yaml" ]; then
    echo "Packaging chart: $chart"
    helm package "$chart" --destination "$TMP_DIR"
  else
    echo "Skipping directory (no Chart.yaml found): $chart"
  fi
done

echo "Generating index.yaml using URL: $REPO_URL"
helm repo index "$TMP_DIR" --url "$REPO_URL"

# Switch to the gh-pages branch (or create it if it doesn't exist).
if git rev-parse --verify "$GH_PAGES_BRANCH" >/dev/null 2>&1; then
  echo "Switching to existing branch: $GH_PAGES_BRANCH"
  git checkout "$GH_PAGES_BRANCH"
else
  echo "Creating orphan branch: $GH_PAGES_BRANCH"
  git checkout --orphan "$GH_PAGES_BRANCH"
  # Remove any existing tracked files if they exist.
  if [ -n "$(git ls-files)" ]; then
    git rm -rf . > /dev/null 2>&1 || true
  fi
fi

# Remove any untracked files.
rm -rf * 2>/dev/null || true

# Copy packaged charts and index.yaml from the temporary directory.
echo "Copying new chart packages and index.yaml into branch..."
cp -r "$TMP_DIR"/* .

# Clean up the temporary directory.
rm -rf "$TMP_DIR"

# Add, commit, and push changes.
echo "Adding files..."
git add .
echo "Committing changes..."
git commit -m "Publish Helm charts on $(date '+%Y-%m-%d %H:%M:%S')" || echo "Nothing to commit."
echo "Pushing changes to remote branch: $GH_PAGES_BRANCH"
git push origin "$GH_PAGES_BRANCH"

# Switch back to the original branch if it was set.
if [ -n "$CURRENT_BRANCH" ]; then
  echo "Switching back to original branch: $CURRENT_BRANCH"
  git checkout "$CURRENT_BRANCH"
fi

echo "Helm charts successfully published to GitHub Pages at: $REPO_URL"
