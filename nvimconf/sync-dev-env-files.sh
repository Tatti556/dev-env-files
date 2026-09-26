#!/usr/bin/env bash
set -euo pipefail

source_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_url="https://github.com/Tatti556/dev-env-files.git"

if ! git -C "$source_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "nvim Git repository was not found: $source_dir" >&2
  exit 1
fi

if ! git -C "$source_dir" diff --quiet HEAD --; then
  echo "Commit the nvim changes before syncing. Only HEAD is exported." >&2
  exit 1
fi

temp_dir="$(mktemp -d)"
cleanup() {
  if [[ -n "$temp_dir" && -d "$temp_dir" ]]; then
    rm -rf -- "$temp_dir"
  fi
}
trap cleanup EXIT

git clone --quiet --branch main --single-branch "$repo_url" "$temp_dir/dev-env-files"
target_dir="$temp_dir/dev-env-files/nvimconf"
rm -rf -- "$target_dir"
mkdir -p -- "$target_dir"
git -C "$source_dir" archive HEAD | tar -xf - -C "$target_dir"

git -C "$temp_dir/dev-env-files" add -f -A -- nvimconf
git -C "$temp_dir/dev-env-files" diff --cached --check

if git -C "$temp_dir/dev-env-files" diff --cached --quiet; then
  echo "dev-env-files/nvimconf is already up to date."
  exit 0
fi

git -C "$temp_dir/dev-env-files" --no-pager diff --cached
printf '\nCommit and push these changes to dev-env-files/main? [y/N] '
read -r answer
if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
  echo "Canceled without committing or pushing."
  exit 0
fi

git -C "$temp_dir/dev-env-files" commit -m "Update Neovim config"
git -C "$temp_dir/dev-env-files" push origin HEAD:main
echo "Updated dev-env-files/nvimconf."
