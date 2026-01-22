<h1 align="center">yamlint</h1>

<p align="center">
  <img src="https://img.shields.io/badge/ruby-%3E%3D%203.1-ruby.svg" alt="Ruby Version"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"><a href="https://github.com/ydah/yamlint/actions/workflows/test.yml"><img src="https://github.com/ydah/yamlint/actions/workflows/test.yml/badge.svg?branch=main" alt="test"></a><a href="https://badge.fury.io/rb/yamlint"><img src="https://badge.fury.io/rb/yamlint.svg" alt="Gem Version"></a>
</p>

<p align="center">
  A Ruby CLI for linting and formatting YAML files
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#quickstart">Quickstart</a> •
  <a href="#installation">Installation</a> •
  <a href="#usage">Usage</a> •
  <a href="#configuration">Configuration</a> •
  <a href="#rules">Rules</a>
</p>

## Features

- Rule-based linting and auto-formatting
- Configuration via `.yamllint(.yml/.yaml)` with preset `extends`
- CI-friendly output formats (standard/parsable/colored/github)
- YAML file patterns and ignore support

## Quickstart

```bash
gem install yamlint

# lint
yamlint .

# format (dry-run)
yamlint format --dry-run .
```

## Installation

With Bundler:

```bash
bundle add yamlint
```

Without Bundler:

```bash
gem install yamlint
```

## Usage

Basic:

```bash
yamlint .
yamlint path/to/file.yml
```

Formatting:

```bash
yamlint format .
yamlint format --dry-run .
```

CI output:

```bash
yamlint -f github .
```

Help:

```bash
yamlint --help
```

## Configuration

Default config file names:

- `.yamllint`
- `.yamllint.yml`
- `.yamllint.yaml`

Configuration options:

| Option | Type | Default | Behavior |
| --- | --- | --- | --- |
| `extends` | string | none | Inherit a preset (`default` or `relaxed`). Values from the current file override the preset. |
| `yaml-files` | list of glob strings | `["*.yaml", "*.yml"]` | Glob patterns used when discovering YAML files in directories. |
| `ignore` | list of strings | `[]` | List of paths to skip. Parsed by the config loader but not currently applied to file discovery. |
| `rules` | map | `{}` | Per-rule configuration. Set a rule to `disable` or `false` to turn it off, or provide a map of options. |

Notes:

- Rule option keys accept either `snake_case` or `kebab-case` and are normalized internally.
- Rule option defaults come from the rule implementation and are merged with your overrides.

Example:

```yaml
extends: default

yaml-files:
  - "*.yml"
  - "*.yaml"

ignore:
  - vendor
  - node_modules

rules:
  line-length:
    max: 120
  document-start: disable
  truthy:
    allowed-values: ["true", "false"]
```

## Presets

Available presets:

- `default`
- `relaxed`

```yaml
extends: relaxed
```

## Rules

Key rules:

- anchors, braces, brackets, colons, commas, comments, comments-indentation
- document-start, document-end, empty-lines, empty-values, float-values
- hyphens, indentation, key-duplicates, key-ordering, line-length
- new-lines, new-line-at-end-of-file, octal-values, quoted-strings
- trailing-spaces, truthy

## Output formats

Use `-f`/`--format` to select an output format:

- `standard`
- `parsable`
- `colored`
- `github`

## Development

```bash
bin/setup
rake spec
```

Install locally:

```bash
bundle exec rake install
```

Release:

```bash
bundle exec rake release
```

## License

MIT License. See `LICENSE.txt` for details.
