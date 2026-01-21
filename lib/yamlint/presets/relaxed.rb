# frozen_string_literal: true

module Yamlint
  module Presets
    RELAXED = {
      rules: {
        'anchors' => 'disable',
        'braces' => { 'forbid' => false, 'min-spaces-inside' => 0, 'max-spaces-inside' => 1 },
        'brackets' => { 'forbid' => false, 'min-spaces-inside' => 0, 'max-spaces-inside' => 1 },
        'colons' => { 'max-spaces-before' => 1, 'max-spaces-after' => 1 },
        'commas' => { 'max-spaces-before' => 1, 'min-spaces-after' => 1, 'max-spaces-after' => 1 },
        'comments' => 'disable',
        'comments-indentation' => 'disable',
        'document-end' => 'disable',
        'document-start' => 'disable',
        'empty-lines' => 'disable',
        'empty-values' => 'disable',
        'float-values' => 'disable',
        'hyphens' => 'disable',
        'indentation' => 'disable',
        'key-duplicates' => {},
        'key-ordering' => 'disable',
        'line-length' => { 'max' => 120, 'allow-non-breakable-words' => true,
                           'allow-non-breakable-inline-mappings' => true },
        'new-line-at-end-of-file' => 'disable',
        'new-lines' => { 'type' => 'unix' },
        'octal-values' => 'disable',
        'quoted-strings' => 'disable',
        'trailing-spaces' => 'disable',
        'truthy' => 'disable'
      }
    }.freeze
  end
end
