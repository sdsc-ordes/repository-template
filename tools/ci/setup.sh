#!/usr/bin/env bash

set -e
set -u

ROOT_DIR=$(git rev-parse --show-toplevel)
. "$ROOT_DIR/tools/ci/general.sh"

ci::print_info "Linking configs files to root."
cd "$ROOT_DIR"

rm -rf ".prettierrc.yaml" || true
ln -s "tools/configs/prettier/prettierrc.yaml" ".prettierrc.yaml"

rm -rf ".typos.toml" || true
ln -s "tools/configs/typos/typos.toml" ".typos.toml"

rm -rf ".yamllint.yaml" || true
ln -s "tools/configs/yamllint/yamllint.yaml" ".yamllint.yaml"
