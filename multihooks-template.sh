#!/usr/bin/env bash

# Allow multiple hooks.
#
# To use it copy file to ./git/hooks directory or to directory pointed in git config core.hooksPath.
# Next create symbolic links from this file to hook files. This script should have execution rights.
# Put your scripts in <<HOOK_NAME>>.d folders in your hook directory. Scripts will be executed in
#
# Original code https://gist.github.com/damienrg/411f63a5120206bb887929f4830ad0d0
#

hook_type=${BASH_SOURCE##*/}
hook_dir="${BASH_SOURCE[0]}.d"

case "$hook_type" in
  applypatch-msg | \
  commit-msg | \
  fsmonitor-watchman | \
  post-checkout | \
  post-commit | \
  post-merge | \
  post-update | \
  post-receive | \
  pre-applypatch | \
  pre-commit | \
  prepare-commit-msg | \
  pre-push | \
  pre-rebase | \
  pre-receive | \
  update)
  IFS= read -rd '' stdin
  if [[ -d $hook_dir && "$(ls -I .gitkeep -A ${hook_dir})" ]]; then
      for file in "${hook_dir}"/*; do
        "./$file" "$@" <<<"$stdin" || exit 2
      done
  fi
  exit 0
  ;;
*)
  echo "unknown hook type: $hook_type"
  exit 2
  ;;
esac
