# frozen_string_literal: true

module Yamlint
  module Output
    class Colored < Base
      COLORS = {
        reset: "\e[0m",
        bold: "\e[1m",
        red: "\e[31m",
        yellow: "\e[33m",
        cyan: "\e[36m",
        dim: "\e[2m"
      }.freeze

      def format(filepath, problems)
        return '' if problems.empty?

        lines = ["#{COLORS[:bold]}#{filepath}#{COLORS[:reset]}"]
        problems.each do |problem|
          lines << format_problem(problem)
        end
        lines.join("\n")
      end

      def format_summary(total_files, total_problems)
        if total_problems.zero?
          format_success_summary(total_files)
        else
          format_failure_summary(total_files, total_problems)
        end
      end

      private

      def format_problem(problem)
        color = problem.error? ? COLORS[:red] : COLORS[:yellow]
        pos = "#{COLORS[:dim]}#{problem.line}:#{problem.column}#{COLORS[:reset]}"
        level = "#{color}#{problem.level}#{COLORS[:reset]}"
        rule = "#{COLORS[:cyan]}(#{problem.rule})#{COLORS[:reset]}"
        "  #{pos}      #{level}   #{problem.message}  #{rule}"
      end

      def format_success_summary(total_files)
        "#{COLORS[:bold]}#{total_files}#{COLORS[:reset]} file(s) checked, " \
          "#{COLORS[:bold]}no problems found#{COLORS[:reset]}"
      end

      def format_failure_summary(total_files, total_problems)
        "#{COLORS[:bold]}#{total_files}#{COLORS[:reset]} file(s) checked, " \
          "#{COLORS[:red]}#{total_problems} problem(s) found#{COLORS[:reset]}"
      end
    end
  end
end
