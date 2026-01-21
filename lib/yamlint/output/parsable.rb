# frozen_string_literal: true

module Yamlint
  module Output
    class Parsable < Base
      def format(filepath, problems)
        return '' if problems.empty?

        problems.map do |problem|
          "#{filepath}:#{problem.line}:#{problem.column}: [#{problem.level}] #{problem.message} (#{problem.rule})"
        end.join("\n")
      end

      def format_summary(_total_files, _total_problems)
        ''
      end
    end
  end
end
