# frozen_string_literal: true

require_relative 'yamlint/version'

module Yamlint
  autoload :Models, 'yamlint/models'
  autoload :Parser, 'yamlint/parser'
  autoload :Rules, 'yamlint/rules'
  autoload :Presets, 'yamlint/presets'
  autoload :Config, 'yamlint/config'
  autoload :Linter, 'yamlint/linter'
  autoload :Formatter, 'yamlint/formatter'
  autoload :Runner, 'yamlint/runner'
  autoload :Output, 'yamlint/output'
  autoload :Cli, 'yamlint/cli'
end
