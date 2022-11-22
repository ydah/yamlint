# frozen_string_literal: true

require 'thor'

module Yamlint
  # Provide CLI sub-commands.
  class Cli < ::Thor
    package_name 'yamlint'
    default_command :lint
    desc 'lint', 'Static analysis of YAML files.'
    def lint
      puts 'command'
    end
  end
end
