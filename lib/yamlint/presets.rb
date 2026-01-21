# frozen_string_literal: true

require_relative 'presets/default'
require_relative 'presets/relaxed'

module Yamlint
  module Presets
    def self.get(name)
      case name.to_s
      when 'default'
        DEFAULT
      when 'relaxed'
        RELAXED
      else
        raise ArgumentError, "Unknown preset: #{name}"
      end
    end
  end
end
