# Contribution Guidelines

:tada: **First off, thank you for considering contributing to our project!**
:tada:

This is a community-driven project, so it's people like you that make it useful
and successful. These are some of the many ways to contribute:

- :bug/feat: Submitting bug reports and feature requests

## Ground Rules

The goal is to maintain a diverse community that's pleasant for everyone.
**Please be considerate and respectful of others**. Everyone must abide by our
[Code of Conduct][docs/code-of-conduct.md] and we encourage all to read it
carefully.

## Commit Convention

We use the
[conventional commits](https://www.conventionalcommits.org/en/v1.0.0/)
specification for commit messages and pull/merge-request titles.

### Scopes

Other scopes then the one in the specification are:

- `generic`: If the commit targets only the `generic` template.
- `python`: If the commit targets only the `python` template.
- `rust`: If the commit targets only the `rust` template.
- `go`: If the commit targets only the `go` template.

## Testing

For all task, enter a development shell with `just develop`.

You can run tests with

```bash
just test
```

and also by pushing all repos to a test branch with

```bash
just maintenance upload-all
```

where you can also inspect the Github Action CI.
