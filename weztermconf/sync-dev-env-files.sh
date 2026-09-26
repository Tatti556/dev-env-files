#!/usr/bin/env bash
set -euo pipefail

source_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_url="https://github.com/Tatti556/dev-env-files.git"

# HEAD の内容だけを反映するため、未コミットの変更があれば停止する
if ! git -C "$source_dir" diff --quiet HEAD --; then
  echo "先に WezTerm 側の変更をコミットしてください。" >&2
  exit 1
fi

temp_dir="$(mktemp -d)"
trap 'rm -rf -- "$temp_dir"' EXIT

git clone --quiet --branch main --single-branch \
  "$repo_url" "$temp_dir/dev-env-files"

target_dir="$temp_dir/dev-env-files/weztermconf"
rm -rf -- "$target_dir"
mkdir -p -- "$target_dir"
git -C "$source_dir" archive HEAD | tar -xf - -C "$target_dir"

git -C "$temp_dir/dev-env-files" add -f -A -- weztermconf
git -C "$temp_dir/dev-env-files" diff --cached --check

if git -C "$temp_dir/dev-env-files" diff --cached --quiet; then
  echo "weztermconf は更新済みです。"
  exit 0
fi

git -C "$temp_dir/dev-env-files" --no-pager diff --cached
printf '\nこの差分を dev-env-files/main に push しますか？ [y/N] '
read -r answer
if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
  echo "push せずに終了しました。"
  exit 0
fi

git -C "$temp_dir/dev-env-files" commit -m "Update WezTerm config"
git -C "$temp_dir/dev-env-files" push origin HEAD:main
echo "dev-env-files/weztermconf を更新しました。"