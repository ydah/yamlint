# frozen_string_literal: true

module Yamlint
  module Presets
    DEFAULT = {
      rules: {
        'anchors' => { 'forbid-undeclared-aliases' => true, 'forbid-duplicated-anchors' => true,
                       'forbid-unused-anchors' => true },
        'braces' => { 'forbid' => false, 'min-spaces-inside' => 0, 'max-spaces-inside' => 0 },
        'brackets' => { 'forbid' => false, 'min-spaces-inside' => 0, 'max-spaces-inside' => 0 },
        'colons' => { 'max-spaces-before' => 0, 'max-spaces-after' => 1 },
        'commas' => { 'max-spaces-before' => 0, 'min-spaces-after' => 1, 'max-spaces-after' => 1 },
        'comments' => { 'require-starting-space' => true, 'ignore-shebangs' => true, 'min-spaces-from-content' => 2 },
        'comments-indentation' => {},
        'document-end' => 'disable',
        'document-start' => 'disable',
        'empty-lines' => { 'max' => 2, 'max-start' => 0, 'max-end' => 0 },
        'empty-values' => { 'forbid-in-block-mappings' => true, 'forbid-in-flow-mappings' => true },
        'float-values' => 'disable',
        'hyphens' => { 'max-spaces-after' => 1 },
        'indentation' => { 'spaces' => 2, 'indent-sequences' => true },
        'key-duplicates' => {},
        'key-ordering' => 'disable',
        'line-length' => { 'max' => 80, 'allow-non-breakable-words' => true,
                           'allow-non-breakable-inline-mappings' => true },
        'new-line-at-end-of-file' => {},
        'new-lines' => { 'type' => 'unix' },
        'octal-values' => { 'forbid-implicit-octal' => true, 'forbid-explicit-octal' => false },
        'quoted-strings' => 'disable',
        'trailing-spaces' => {},
        'truthy' => { 'allowed-values' => %w[true false], 'check-keys' => true }
      }
    }.freeze
  end
end
