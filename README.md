# Repository Template

**Vision: SDSC Excellence | Always be encouraging**

Get in contact

- Slack Channel : `#best-practice-ambassadors`

# What Is This?

This is a repository template giving you a top-level structure with the
following features.

- [Git](.gitignore) & [Git LFS](.gitattributes) properly setup.
- [Nix shell](./tools/nix/shells/default/default.nix) enabled with `direnv` and
  [`.envrc`](.envrc):
- Formatting with [`treefmt-nix`](./tools/nix/packages/treefmt/treefmt.nix).
- Githooks (optional) which runs `pre-commit` checks:
  - [Git LFS checks.](.githooks/pre-commit/1-git-lfs-check.sh)
  - [Format with `treefmt-nix`.](.githooks/pre-commit/2-format.sh)
