# Repository Template

**Vision: SDSC Excellence | Always be encouraging**

Get in contact

- Slack Channel : `#best-practice-ambassadors`

Authors:

- [Gabriel Nützi](gabriel.nuetzi@sdsc.ethz.ch)
- [Cyril Matthey-Doret](cyril.matthey-doret@sdsc.ethz.ch)

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
- Language specific best-practice setup for `rust`, `go` and `python`:
  - Toolchain: compiler/interpreters.
  - Language Servers (LSP).
  - etc.

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

  - [`generic`](./src/generic): For a generic repository without any language
    specific needs.
  - [`python`](./src/python): For python toolchain with `uv` and other good
    tooling.
  - [`rust`](./src/rust): For a Rust toolchain with `cargo`
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

## Generic

**TODO**: Description about the different folder etc.

### Toolchain

[Source](src/python/tools/shells/toolchain-generic.nix)

- Command-Runner: `just`
- Formatter: Tree format with `treefmt-nix` and
  [enabled languages](src/generic/tools/nix/packages/treefmt/treefmt.nix.jinja)

## Rust

[Source](src/rust/tools/shells/toolchain-rust.nix)

- Rust-Toolchain: [`nightly`](src/rust/tools/configs/rust/rust-toolchain.toml)
- Build-Tool: `cargo`
- LSP: `rust-analyzer`
- Formatter: `rustfmt`

## Go

[Source](src/go/tools/shells/toolchain-rust.nix)

- Compiler: `go` at `1.23.X`
- Build-Tool: `go`
- LSP: `gopls`
- Formatter: `gofmt`, `goimports`, `golines`

## Python

### Toolchain:

[Source](src/python/tools/shells/toolchain-python.nix)

- Interpreter: `python` at `3.12`
- Build-Tool: `uv`
- LSP: `pyright`
- Formatter: `ruff`
