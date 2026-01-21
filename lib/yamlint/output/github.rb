# frozen_string_literal: true

module Yamlint
  module Output
    class Github < Base
      def format(filepath, problems)
        return '' if problems.empty?

        problems.map do |problem|
          type = problem.error? ? 'error' : 'warning'
          "::#{type} file=#{filepath},line=#{problem.line},col=#{problem.column}::#{problem.message} (#{problem.rule})"
        end.join("\n")
      end

      def format_summary(_total_files, _total_problems)
        ''
      end
    end
  end
end
