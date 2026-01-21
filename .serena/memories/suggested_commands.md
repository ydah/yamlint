# Suggested commands

## Setup
- `bin/setup` (install dependencies)

## Tests
- `bundle exec rake spec`
- `bundle exec rake` (default runs `spec` and `rubocop`)

## Linting
- `bundle exec rubocop`
- `bundle exec rake rubocop`

## Run CLI / console
- `bundle exec exe/yamlint ...` (gem executable)
- `bin/console` (interactive)
- `bin/checker <files...>` (simple YAML load checker)