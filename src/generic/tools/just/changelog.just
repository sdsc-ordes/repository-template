set positional-arguments
set shell := ["bash", "-cue"]

default:
    just --list --unsorted -f "{{source_file()}}"

# Generate the changelog for the tag `tag`
# Only the first-parent reachable commits are taken.
# See: https://github.com/git-chglog/git-chglog/issues/284
[group('aux')]
gen tag config="./tools/configs/git-cliff/config.toml" changelog="CHANGELOG.md":
    just nix::develop changelog \
        generate-changelog "{{tag}}" "{{config}}" "{{changelog}}"
