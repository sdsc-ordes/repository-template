#!/usr/bin/env bash

# Installs Githooks into the repository.
# Used in the devshell entry hook.

set -e
set -u

REPO_DIR=$(git rev-parse --show-toplevel)
cd "$REPO_DIR"

if git hooks --version &>/dev/null; then
    if [ "$(git config --local githooks.registered)" != "true" ]; then
        git hooks install
    else
        echo "Githooks already installed."
    fi
fi
