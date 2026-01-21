# frozen_string_literal: true

module Yamlint
  module Output
    class Base
      def format(filepath, problems)
        raise NotImplementedError, "#{self.class}#format must be implemented"
      end

      def format_summary(total_files, total_problems)
        raise NotImplementedError, "#{self.class}#format_summary must be implemented"
      end
    end
  end
end
