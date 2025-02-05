<p align="center">
  <img src="./docs/assets/logo.svg" alt="project logo" width="250">
</p>

<h1 align="center">
Repository Template
</h1>
<p align="center">
</p>
<p align="center">
  <a href="https://github.com/swissdatasciencecenter/my-project/releases/latest">
    <img src="https://img.shields.io/github/release/swissdatasciencecenter/my-project.svg?label=release" alt="Current Release" />
  </a>
  <a href="https://github.com/swissdatasciencecenter/ my-project/actions/workflows/main-and-pr.yaml">
    <img src="https://img.shields.io/github/actions/workflow/status/swissdatasciencecenter/my-project/main-and-pr.yaml?label=ci" alt="Pipeline Status" />
  </a>
  <a href="http://www.apache.org/licenses/LICENSE-2.0.html">
    <img src="https://img.shields.io/badge/License-Apache2.0-blue.svg?" alt="License label" />
  </a>
</p>

**Vision: SDSC Excellence | Always be encouraging**

Get in contact

- Slack Channel : `#best-practice-ambassadors`

Authors:

- [Gabriel Nützi](gabriel.nuetzi@sdsc.ethz.ch)
- [Cyril Matthey-Doret](cyril.matthey-doret@sdsc.ethz.ch)

<details>
<summary><b>Table of Content (click to expand)</b></summary>

<!--toc:start-->

- [Repository Template](#repository-template)
- [What Is This?](#what-is-this)
- [Usage](#usage)
  - [Cloning](#cloning)
  - [Containerized](#containerized)
- [Structure](#structure)
  - [Generic Template](#generic-template)
    - [Features](#features)
    - [Toolchain](#toolchain)
  - [Rust Template](#rust-template)
    - [Toolchain](#toolchain)
  - [Go Template](#go-template)
    - [Toolchain](#toolchain)
  - [Python Template](#python-template) - [Toolchain](#toolchain)
  <!--toc:end-->

</details>

# What Is This?

This is a repository template giving you a top-level structure with the
following features.

- **Git & Git Large File System (LFS)** properly setup.
- **Nix development shell** enabled with [`direnv`](https://direnv.net) and
  `.envrc`.
- Formatting with [`treefmt-nix`](https://github.com/numtide/treefmt-nix).
- [Githooks](https://github.com/gabyx/githooks) (optional) which runs
  `pre-commit` checks:
  - Git LFS checks.
  - Format with `treefmt-nix`.
- Language specific best-practice setup for [`rust`](#rust-template),
  [`go`](#go-template) and [`python`](#python-template).
- [Devcontainer](https://containers.dev): _not-yet-provided_ (future, based on
  Nix dev shell)

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
  - [`go`](./src/go): For a default Go toolchain.

- `[args...]` are optional arguments passed to `copier`. If you want to
  overwrite by default use `-w`.

## Containerized

TODO: Add this.

# Structure

The following describes the content of the top-level directories:

- [`docs`](src/generic/docs) : The top-level folder to any related
  documentation. The [README.md](src/generic/README.md) should link into this
  folder.
- [`examples`](src/generic/examples) : The top-level folder which should contain
  some examples how to use this software component.
- [`external`](src/generic/external) : If you really want to use sub-modules
  (which you generally should avoid for a multitude of reasons), your external
  stuff should be either placed in here or in `src/external` if its more related
  to your source.
- `src`: The folder where your source code lives.
- [`tools`](src/generic/tools): The folder for all specific needs:
  - [`configs`](src/generic/tools/configs): A collection folder for all config
    related files for certain tools like, e.g. formatters, linters etc.
  - [`nix`](src/generic/tools/nix): The folder containing all Nix related stuff.
  - [`ci`](src/generic/tools/ci): Folder containing all CI related
    tooling/scripts.
  - [`scripts`](src/generic/tools/scripts): Folder containing additional scripts
    complementing the `justfile` etc.

## Generic Template

[Template Source](src/generic)

### Features

- **Git & Git LFS** properly setup:
  [`.gitignore`](src/generic/.gitignore.jinja),
  [`.gitattributes`](src/generic/.gitattributes)

- **Nix development shell** based on `devenv` auto-enabled with `direnv` and
  [`.envrc`](src/generic/.envrc).

- Formatting with [`treefmt-nix`](https://github.com/numtide/treefmt-nix) and
  [`treefmt.nix` config](src/generic/tools/nix/packages/treefmt/treefmt.nix.jinja).

- [Githooks](https://github.com/gabyx/githooks) (optional) which runs
  `pre-commit` checks:

  - [Git LFS checks](src/generic/.githooks/pre-commit/1-git-lfs-check.sh)
  - [Format](src/generic/.githooks/pre-commit/2-format.sh) with `treefmt-nix`.

  > [!NOTE] You need to install the
  > [Githooks](https://github.com/gabyx/githooks) tool yourself if you want to
  > use it and it will work out-of-the-box.

### Toolchain

[Source](src/generic/tools/nix/shells/toolchain-generic.nix)

- Command-Runner: `just`
- Nix Shell: `devenv` provided Nix shell using
  [toolchain-generic.nix](src/generic/tools/nix/shells/toolchain-generic.nix).
- Formatter: Tree format with `treefmt-nix` and
  [enabled languages](src/generic/tools/nix/packages/treefmt/treefmt.nix.jinja)

## Rust Template

[Template Source](src/rust)

### Toolchain

[Source](src/rust/tools/nix/shells/toolchain-rust.nix)

- Toolchain: Rust toolchain on
  [`nightly`](src/rust/tools/configs/rust/rust-toolchain.toml)
- Build-Tool: `cargo`
- LSP: `rust-analyzer`
- Formatter: `rustfmt`

## Go Template

[Template Source](src/go)

### Toolchain

[Source](src/go/tools/nix/shells/toolchain-go.nix)

- Compiler: `go` at `1.23.X`
- Build-Tool: `go`
- LSP: `gopls`
- Formatter: `gofmt`, `goimports`, `golines`

## Python Template

[Template Source](src/python)

### Toolchain

[Source](src/python/tools/nix/shells/toolchain-python.nix)

- Interpreter: `python` at `3.12`
- Build-Tool: `uv`
- LSP: `pyright`
- Formatter: `ruff`

## Development

Read first the [Contribution Guidelines](/CONTRIBUTING.md).

For technical documentation on setup and development, see the
[Development Guide](docs/development-guide.md)

## Copyright

Copyright © 2025-2028 Swiss Data Science Center (SDSC),
[www.datascience.ch](http://www.datascience.ch/). All rights reserved. The SDSC
is jointly established and legally represented by the École Polytechnique
Fédérale de Lausanne (EPFL) and the Eidgenössische Technische Hochschule Zürich
(ETH Zürich). This copyright encompasses all materials, software, documentation,
and other content created and developed by the SDSC.
