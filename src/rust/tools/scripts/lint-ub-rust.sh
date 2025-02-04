#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091
set -e
set -u

ROOT_DIR=$(git rev-parse --show-toplevel)
. "$ROOT_DIR/tools/ci/general.sh"

cd "$ROOT_DIR"

cargo --version
cargo miri --version

ci::print_info "Run Rust Miri to check undefined behavior."
cargo miri test "$@" ||
    ci::die "Rust Miri failed."

ci::print_info "Done."
