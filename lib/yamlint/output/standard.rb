# frozen_string_literal: true

module Yamlint
  module Output
    class Standard < Base
      def format(filepath, problems)
        return '' if problems.empty?

        lines = [filepath]
        problems.each do |problem|
          lines << "  #{problem.line}:#{problem.column}      #{problem.level}   #{problem.message}  (#{problem.rule})"
        end
        lines.join("\n")
      end

      def format_summary(total_files, total_problems)
        if total_problems.zero?
          "#{total_files} file(s) checked, no problems found"
        else
          "#{total_files} file(s) checked, #{total_problems} problem(s) found"
        end
      end
    end
  end
end
