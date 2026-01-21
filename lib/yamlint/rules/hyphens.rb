# frozen_string_literal: true

require 'English'
module Yamlint
  module Rules
    class Hyphens < LineRule
      rule_id 'hyphens'
      desc 'Check space after hyphens.'
      defaults({
                 'max-spaces-after': 1
               })

      def check_line(line, line_number, _context)
        return if line.strip.empty?
        return if line.strip.start_with?('#')

        problems = []
        max_after = @config[:'max-spaces-after']

        line.scan(/^(\s*)-(\s+)/) do |_indent, spaces|
          next if spaces.length <= max_after

          pos = $LAST_MATCH_INFO.begin(2)
          problems << problem(
            line: line_number,
            column: pos + 1,
            message: "too many spaces after hyphen (#{spaces.length} > #{max_after})",
            fixable: true
          )
        end

        problems
      end

      def fixable?
        true
      end
    end

    Registry.register(Hyphens)
  end
end
