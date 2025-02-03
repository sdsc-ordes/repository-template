# Repository Template

**Vision: SDSC Excellence | Always be encouraging**

Get in contact

- Slack Channel : `#best-practice-ambassadors`

# What Is This?

This is a repository template giving you a top-level structure with the
following features.

- [Git](.gitignore) & [Git LFS](.gitattributes) properly setup.
- [Nix shell](./tools/nix/shells/default/default.nix) enabled with `direnv` and
  [`.envrc`](.envrc).
- Formatting with [`treefmt-nix`](./tools/nix/packages/treefmt/treefmt.nix).
- Githooks (optional) which runs `pre-commit` checks:
  - [Git LFS checks.](.githooks/pre-commit/1-git-lfs-check.sh)
  - [Format with `treefmt-nix`.](.githooks/pre-commit/2-format.sh)
- Language specific best-practice setup for `rust`, `go` and `python`.

# Usage

## Cloning

Clone this repository to some place of your choice.

Apply the templates with `copier` using the following:

```shell
cd repo && git pull
just create <language> <destination> [args...]
```

where

- `<destination>` is the destination folder where you want to place this new
  repository.
- `<language>` is one of the following templates:

  - [`python`](./src/python)
  - [`rust`](./src/rust)
  - [`go`](./src/go)

- `[args...]` are optional arguments passed to `copier`. If you want to
  overwrite by default use `-w`

## Containerized

TODO: Add this.

# Structure

The following describes the content of the top-level directories:

- [docs](./src/generic/docs) : The top-level folder to any related
  documentation. The [README.md](./src/generic/README.md) should link into this
  folder.
- [examples](./src/generic/examples) : The top-level folder which should contain
  some examples how to use this software component.
- [external](./src/generic/external) : If you really want to use sub-modules
  (which you generally should avoid for a multitude of reasons), your external
  stuff should be either placed in here or in `src/external` if its more related
  to your source.
- `build` : This is a reserved Git ignored top-level folder only for the build
  output.

## Python

TODO

## Rust

TODO

## Go

TODO
