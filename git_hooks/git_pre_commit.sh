#!/usr/bin/env bash

current_repo_path=$(git rev-parse --show-toplevel)
if [[ -e $current_repo_path/format/format-objc-hook ]]; then
   $current_repo_path/format/format-objc-hook || exit 1;
fi

