# frozen_string_literal: true

require 'yaml'

module Yamlint
  module Parser
    class TokenParser
      class Handler < Psych::Handler
        attr_reader :tokens

        def initialize
          super
          @tokens = []
          @parser = nil
        end

        attr_writer :parser

        def start_stream(encoding)
          add_token(:stream_start, encoding:)
        end

        def end_stream
          add_token(:stream_end)
        end

        def start_document(version, tag_directives, implicit)
          add_token(:document_start, version:, tag_directives:, implicit:)
        end

        def end_document(implicit)
          add_token(:document_end, implicit:)
        end

        def start_mapping(anchor, tag, implicit, style)
          add_token(:mapping_start, anchor:, tag:, implicit:, style:)
        end

        def end_mapping
          add_token(:mapping_end)
        end

        def start_sequence(anchor, tag, implicit, style)
          add_token(:sequence_start, anchor:, tag:, implicit:, style:)
        end

        def end_sequence
          add_token(:sequence_end)
        end

        def scalar(value, anchor, tag, plain, quoted, style)
          add_token(:scalar, value:, anchor:, tag:, plain:, quoted:, style:)
        end

        def alias(anchor)
          add_token(:alias, anchor:)
        end

        private

        def add_token(type, **attrs)
          mark = @parser&.mark
          token = Models::Token.new(
            type:,
            value: attrs[:value],
            start_line: mark ? mark.line + 1 : 1,
            start_column: mark ? mark.column + 1 : 1
          )
          @tokens << token
        end
      end

      def initialize(content)
        @content = content
      end

      def parse
        handler = Handler.new
        parser = Psych::Parser.new(handler)
        handler.parser = parser

        begin
          parser.parse(@content)
        rescue Psych::SyntaxError
          # Syntax errors will be handled separately
        end

        handler.tokens
      end
    end
  end
end
