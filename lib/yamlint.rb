# frozen_string_literal: true

require_relative 'yamlint/version'

module Yamlint
  autoload :Cli, 'yamlint/cli'
  autoload :Commands, 'yamlint/commands'
end
