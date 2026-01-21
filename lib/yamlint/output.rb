# frozen_string_literal: true

module Yamlint
  module Output
    autoload :Base, 'yamlint/output/base'
    autoload :Standard, 'yamlint/output/standard'
    autoload :Parsable, 'yamlint/output/parsable'
    autoload :Colored, 'yamlint/output/colored'
    autoload :Github, 'yamlint/output/github'

    def self.get(format)
      case format.to_s
      when 'standard'
        Standard.new
      when 'parsable'
        Parsable.new
      when 'colored', 'auto'
        Colored.new
      when 'github'
        Github.new
      else
        raise ArgumentError, "Unknown output format: #{format}"
      end
    end
  end
end
