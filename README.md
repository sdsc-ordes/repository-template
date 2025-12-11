<p align="center">
  <img src="./docs/assets/logo.svg" alt="project logo" width="150">
</p>

<h1 align="center">
Repository Template
</h1>
<p align="center">
</p>
<p align="center">
  <a href="https://github.com/sdsc-ordes/repository-template/releases/latest">
    <img src="https://img.shields.io/github/release/sdsc-ordes/repository-template.svg?label=release" alt="Current Release" />
  </a>
  <a href="https://github.com/sdsc-ordes/repository-template/actions/workflows/normal.yaml">
    <img src="https://img.shields.io/github/actions/workflow/status/sdsc-ordes/repository-template/normal.yaml?label=ci" alt="Pipeline Status" />
  </a>
  <a href="http://www.apache.org/licenses/LICENSE-2.0.html">
    <img src="https://img.shields.io/badge/License-Apache2.0-blue.svg?" alt="License label" />
  </a>
</p>

Authors:

- Gabriel Nützi [@gabyx](https://github.com/gabyx)
- Cyril Matthey-Doret [@cmdoret](https://github.com/cmdoret)

<details>
<summary><b>Table of Content (click to expand)</b></summary>

<!--toc:start-->

- [What Is This?](#what-is-this)
- [Usage](#usage)
  - [Over Container](#over-container)
  - [By Cloning](#by-cloning)
  - [Arguments](#arguments)
- [Structure](#structure)
  - [Generic Template](#generic-template)
    - [Toolchain](#toolchain)
  - [Rust Template](#rust-template)
    - [Toolchain](#toolchain)
  - [Go Template](#go-template)
    - [Toolchain](#toolchain)
  - [Python Template](#python-template)
    - [Toolchain](#toolchain)
  - [CI Implementations](#ci-implementations)
    - [Github Actions](#github-actions)
- [Development](#development)
- [Copyright](#copyright)

<!--toc:end-->

</details>

# What Is This?

This repo renders **repository templates** for different languages giving you a
top-level structure with the following features.

<p align="center">
  <img src="./docs/assets/templating.png" alt="Current Release" width="50%"   style="border: 5pt solid #aaaaaa; border-radius:5pt"/>
</p>

- **Git & Git Large File System (LFS)** configured.
- **Nix development shell** enabled with [`direnv`](https://direnv.net) and
  `.envrc`.
- Language specific best-practice setup for [`rust`](#rust-template),
  [`go`](#go-template) or [`python`](#python-template).
- Formatting with [`treefmt-nix`](https://github.com/numtide/treefmt-nix).
- [Githooks](https://github.com/gabyx/githooks) (optional) which runs
  `pre-commit` checks:
  - Git LFS checks.
  - Format with `treefmt-nix`.
- [Devcontainer](https://containers.dev): _not-yet-provided_ (future, based on
  Nix dev shell)

# Usage

To render a new repository for language `<language>` you can use

## Over Container

```bash
mkdir repo
podman run -it -v "$(pwd)/repo:/workspace" \
  ghcr.io/sdsc-ordes/repository-template:latest \
  -t "<language>" -d "." [-- ["args-to-copier"...]]
```

> [!CAUTION]
>
> Using `docker` above will create `root`-owned files on your machine (by
> default without some
> [user namespacing](https://docs.docker.com/engine/security/userns-remap/)
> setup etc.), we strongly recommend using `podman` instead.

See [arguments explanations here](#arguments).

## By Cloning

You can also clone this repository to some place of your choice.

Apply the templates with `copier` using the following:

```bash
cd repo && git pull
just create -t "<language>" -d "<destination>" [-- ["args-to-copier"...]]
```

See [arguments explanations here](#arguments).

## Arguments

- `<destination>` is the destination folder where you want to place your new
  repository.
- `<language>` is one of the following templates:
  - [`generic`](./src/generic): For a generic repository without any language
    specific needs.
  - [`python`](./src/python): For python toolchain with `uv` and other good
    tooling.
  - [`rust`](./src/rust): For a Rust toolchain with `cargo`
  - [`go`](./src/go): For a default Go toolchain.

- `[args-to-copier...]` are optional arguments passed to `copier`. If you want
  to overwrite by default use `-w` and not answer `Y` all the time and `-l` to
  apply all defaults to inspect:

  ```shell
  just create -t <language> -d <destination> -- -w -l
  ```

# Structure

The following describes the content of the top-level directories:

- [`docs`](src/generic/docs) : All documentation-related files. The
  [README.md](src/generic/README.md) should link into this folder.
- [`examples`](src/generic/examples) : Examples showing how to use this software
  component.
- [`external`](src/generic/external) : Third party resources imported with git
  submodules, [vendir](https://carvel.dev/vendir/) or other tools.
- `src`: Where your source code lives.
- [`tools`](src/generic/tools): Specific needs which are not part of the source:
  - [`configs`](src/generic/tools/configs): config related files for certain
    tools like, e.g. formatters, linters etc.
  - [`nix`](src/generic/tools/nix): Nix related stuff.
  - [`ci`](src/generic/tools/ci): CI related tooling/scripts.
  - [`scripts`](src/generic/tools/scripts): Additional scripts complementing the
    `justfile` etc.

## Generic Template

- [Template Source](src/generic)
- [Demo Rendering](https://github.com/sdsc-ordes/repository-template-generic)

### Toolchain

[Source](src/generic/tools/nix/shells/toolchain-generic.nix)

- Command-Runner: `just`
- Nix Shell: `devenv` provided Nix shell using
  [toolchain-generic.nix](src/generic/tools/nix/shells/toolchain-generic.nix).
- Formatter: Tree format with `treefmt-nix` and
  [enabled languages](src/generic/tools/nix/packages/treefmt/treefmt.nix.jinja)

## Rust Template

- [Template Source](src/rust)
- [Demo Rendering](https://github.com/sdsc-ordes/repository-template-rust)

### Toolchain

[Source](src/rust/tools/nix/shells/toolchain-rust.nix)

- Toolchain: Rust toolchain on
  [`nightly`](src/rust/tools/configs/rust/rust-toolchain.toml)
- Build-Tool: `cargo`
- LSP: `rust-analyzer`
- Formatter: `rustfmt`

## Go Template

- [Template Source](src/go)
- [Demo Rendering](https://github.com/sdsc-ordes/repository-template-go)

### Toolchain

[Source](src/go/tools/nix/shells/toolchain-go.nix)

- Compiler: `go` at `1.24.X`
- Build-Tool: `go`
- LSP: `gopls`
- Formatter: `gofmt`, `goimports`, `golines`

## Python Template

[Template Source](src/python)

### Toolchain

- [Source](src/python/tools/nix/shells/toolchain-python.nix)
- [Demo Rendering](https://github.com/sdsc-ordes/repository-template-python)

- Interpreter: `python` at `3.13`
- Build-Tool: `uv`
- LSP: `pyright`
- Formatter: `ruff`

## CI Implementations

### Github Actions

The following workflows are defined:

- [`format.yaml`](./src/generic/.github/workflows/format.yaml): Formats the
  whole repository with `treefmt`, configured over Nix. For it to work with
  `cachix` (a Nix CI caching mechanism) you need to define two secrets in
  **Settings** -> **Secrets & variables** -> **Actions** -> **Repositories
  secrets**:
  - `CACHIX_CACHE_NAME`: The cache name you created on
    [cachix.org](https://cachix.org). This is free for public caches, which is
    acceptable for OSS repositories.

  - `CACHIX_AUTH_TOKEN`: The access token created on
    [cachix.org](https://cachix.org) for this cache `CACHIX_CACHE_NAME`.

# Development

Read first the [Contribution Guidelines](/CONTRIBUTING.md).

For technical documentation on setup and development, see the
[Development Guide](docs/development-guide.md)

# Copyright

Copyright © 2025-2028 Swiss Data Science Center (SDSC),
[www.datascience.ch](http://www.datascience.ch/). All rights reserved. The SDSC
is jointly established and legally represented by the École Polytechnique
Fédérale de Lausanne (EPFL) and the Eidgenössische Technische Hochschule Zürich
(ETH Zürich). This copyright encompasses all materials, software, documentation,
and other content created and developed by the SDSC.
