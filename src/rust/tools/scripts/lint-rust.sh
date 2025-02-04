#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091
set -e
set -u

ROOT_DIR=$(git rev-parse --show-toplevel)
. "$ROOT_DIR/tools/ci/general.sh"

cd "$ROOT_DIR"

cargo --version
cargo clippy --version

ci::print_info "Run Rust Clippy linter."

cargo clippy --no-deps "$@" ||
    {
        git diff --name-status || true
        ci::die "Rust clippy failed."
    }

ci::print_info "Done."
