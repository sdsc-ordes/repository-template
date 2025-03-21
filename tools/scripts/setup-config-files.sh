#!/usr/bin/env bash

set -e
set -u

ROOT_DIR=$(git rev-parse --show-toplevel)
. "$ROOT_DIR/tools/ci/general.sh"

function link_config_files() {
    cd "$ROOT_DIR"

    ci::print_info "Linking configs files to root."

    rm -rf ".prettierrc.yaml" || true
    ln -s "tools/configs/prettier/prettierrc.yaml" ".prettierrc.yaml"

    rm -rf ".typos.toml" || true
    ln -s "tools/configs/typos/typos.toml" ".typos.toml"

    rm -rf ".yamllint.yaml" || true
    ln -s "tools/configs/yamllint/yamllint.yaml" ".yamllint.yaml"
}

link_config_files
