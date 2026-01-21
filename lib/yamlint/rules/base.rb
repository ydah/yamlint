# frozen_string_literal: true

module Yamlint
  module Rules
    class Base
      class << self
        attr_reader :id, :description, :default_options

        def rule_id(id)
          @id = id
        end

        def desc(description)
          @description = description
        end

        def defaults(options)
          @default_options = options
        end

        def inherited(subclass)
          super
          subclass.instance_variable_set(:@default_options, {})
        end
      end

      attr_reader :config, :level

      def initialize(config = {})
        @config = (self.class.default_options || {}).merge(config)
        @level = @config[:level] || :error
      end

      def check(_context)
        raise NotImplementedError, "#{self.class}#check must be implemented"
      end

      def fixable?
        false
      end

      protected

      def problem(line:, column:, message:, fixable: false)
        Models::Problem.new(
          line:,
          column:,
          rule: self.class.id,
          level: @level,
          message:,
          fixable:
        )
      end
    end

    class LineRule < Base
      def check(context)
        problems = []
        context.lines.each_with_index do |line, index|
          line_number = index + 1
          line_problems = check_line(line, line_number, context)
          problems.concat(Array(line_problems))
        end
        problems
      end

      def check_line(_line, _line_number, _context)
        raise NotImplementedError, "#{self.class}#check_line must be implemented"
      end
    end

    class TokenRule < Base
      def check(context)
        problems = []
        context.tokens.each do |token|
          token_problems = check_token(token, context)
          problems.concat(Array(token_problems))
        end
        problems
      end

      def check_token(_token, _context)
        raise NotImplementedError, "#{self.class}#check_token must be implemented"
      end
    end

    class CommentRule < Base
      def check(context)
        problems = []
        context.comments.each do |comment|
          comment_problems = check_comment(comment, context)
          problems.concat(Array(comment_problems))
        end
        problems
      end

      def check_comment(_comment, _context)
        raise NotImplementedError, "#{self.class}#check_comment must be implemented"
      end
    end
  end
end
