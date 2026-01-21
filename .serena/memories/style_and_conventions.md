# Style and conventions

- Ruby codebase with `# frozen_string_literal: true` headers.
- RuboCop enabled (plugins: performance, rake, rspec); metrics cops disabled; documentation cop disabled.
- RSpec used for tests; no strict example length/subject cops.
- Target Ruby version in RuboCop: 3.1; project `.ruby-version` is 3.4.8.
- Standard Ruby gem layout and naming under `lib/yamlint`.