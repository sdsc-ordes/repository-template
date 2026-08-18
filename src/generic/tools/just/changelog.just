set positional-arguments
set shell := ["bash", "-cue"]

default:
    just --list --unsorted -f "{{source_file()}}"

# Generate the changelog for the tag `tag`
[group('aux')]
gen name="current" config="./tools/configs/git-cliff/config.toml" changelog="CHANGELOG.md":
    just nix::develop changelog \
        generate-changelog "{{name}}" "{{config}}" "{{changelog}}"
