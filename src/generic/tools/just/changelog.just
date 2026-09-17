set positional-arguments
set shell := ["bash", "-cue"]

default:
    just --list --unsorted -f "{{source_file()}}"

# Generate the changelog for the tag `tag`
[group('aux')]
gen name="current" config="./tools/configs/git-cliff/config.toml" changelog="CHANGELOG.md":
    #!/usr/bin/env bash
    set -eu
    root_dir=$(git rev-parse --show-toplevel) || exit 1
    cd "$root_dir"
    just nix::develop default \
        generate-changelog "{{name}}" "{{config}}" "{{changelog}}"
