# frozen_string_literal: true

require 'English'
module Yamlint
  module Rules
    class Comments < LineRule
      rule_id 'comments'
      desc 'Check comments formatting.'
      defaults({
                 'require-starting-space': true,
                 'ignore-shebangs': true,
                 'min-spaces-from-content': 2
               })

      def check_line(line, line_number, _context)
        return unless line.include?('#')

        problems = []

        return problems if @config[:'ignore-shebangs'] && line_number == 1 && line.start_with?('#!')

        problems.concat(check_starting_space(line, line_number))
        problems.concat(check_spaces_from_content(line, line_number))
        problems
      end

      def fixable?
        true
      end

      private

      def check_starting_space(line, line_number)
        return [] unless @config[:'require-starting-space']

        problems = []

        line.scan(/#([^\s#])/) do |match|
          next if match[0] == '!'

          pos = $LAST_MATCH_INFO.begin(0)
          problems << problem(
            line: line_number,
            column: pos + 1,
            message: 'missing starting space in comment',
            fixable: true
          )
        end

        problems
      end

      def check_spaces_from_content(line, line_number)
        return [] if line.strip.start_with?('#')

        problems = []
        min_spaces = @config[:'min-spaces-from-content']

        if (match = line.match(/(\S)(\s*)#/))
          spaces = match[2].length
          if spaces < min_spaces
            problems << problem(
              line: line_number,
              column: match.begin(0) + 2,
              message: "too few spaces before comment (#{spaces} < #{min_spaces})",
              fixable: true
            )
          end
        end

        problems
      end
    end

    Registry.register(Comments)
  end
end
