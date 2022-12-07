# frozen_string_literal: true

require_relative 'yamlint/version'

module Yamlint
  autoload :AST, 'yamlint/ast'
  autoload :Cli, 'yamlint/cli'
  autoload :Commands, 'yamlint/commands'
  autoload :Parser, 'yamlint/parser'
  autoload :Runner, 'yamlint/runner'
end
