# yamlint project overview

## Purpose
- Pure-Ruby YAML linter and formatter, inspired by Python's `adrienverge/yamllint`.
- Provides CLI linting and auto-fix formatting with yamllint-compatible config intent.

## Tech stack
- Ruby gem (Ruby >= 3.1; `.ruby-version` is 3.4.8).
- Testing: RSpec.
- Linting: RuboCop (+ performance/rake/rspec plugins).

## Rough structure
- `lib/yamlint/`: core implementation
  - `cli.rb`, `runner.rb`: CLI entry logic
  - `linter.rb`, `formatter.rb`, `config.rb`
  - `parser/`, `rules/`, `models/`, `output/`, `presets/`
- `exe/yamlint`: gem executable entrypoint
- `bin/`: developer scripts (`setup`, `console`, `checker`)
- `spec/`: RSpec test suite
- `docs/`: generated documentation
- `yamlint.gemspec`, `Gemfile`, `Rakefile`: gem/build config

## Architecture notes
Design doc (`ruby_yamllint_design_and_instructions.md`) describes layered architecture:
CLI -> core (linter/formatter/config) -> rules registry -> parser -> models.