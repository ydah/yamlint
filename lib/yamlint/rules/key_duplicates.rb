# frozen_string_literal: true

require 'yaml'

module Yamlint
  module Rules
    class KeyDuplicates < Base
      rule_id 'key-duplicates'
      desc 'Forbid duplicated keys in mappings.'
      defaults({})

      def check(context)
        handler = DuplicateKeyHandler.new
        parser = Psych::Parser.new(handler)
        handler.parser = parser

        begin
          parser.parse(context.content)
        rescue Psych::SyntaxError
          return []
        end

        handler.problems.map do |prob|
          problem(
            line: prob[:line],
            column: prob[:column],
            message: "duplicate key \"#{prob[:key]}\"",
            fixable: false
          )
        end
      end

      class DuplicateKeyHandler < Psych::Handler
        attr_reader :problems

        def initialize
          super
          @stack = []
          @problems = []
          @parser = nil
        end

        attr_writer :parser

        def start_mapping(*)
          parent = current_mapping_frame
          @stack << {
            type: :mapping,
            keys: {},
            expecting_key: true,
            close_parent: capture_close_parent(parent)
          }
        end

        def end_mapping
          frame = @stack.pop
          close_parent_value(frame)
        end

        def start_sequence(*)
          parent = current_mapping_frame
          @stack << {
            type: :sequence,
            close_parent: capture_close_parent(parent)
          }
        end

        def end_sequence
          frame = @stack.pop
          close_parent_value(frame)
        end

        def scalar(value, _anchor, _tag, _plain, _quoted, _style)
          frame = @stack.last
          return unless frame && frame[:type] == :mapping

          if frame[:expecting_key]
            current_keys = frame[:keys]
            mark = @parser&.mark

            if current_keys.key?(value)
              @problems << {
                key: value,
                line: mark ? mark.line + 1 : 1,
                column: mark ? mark.column + 1 : 1
              }
            else
              current_keys[value] = true
            end

            frame[:expecting_key] = false
          else
            frame[:expecting_key] = true
          end
        end

        private

        def current_mapping_frame
          frame = @stack.last
          return frame if frame && frame[:type] == :mapping

          nil
        end

        def capture_close_parent(parent)
          return nil unless parent

          if parent[:expecting_key]
            { parent:, expecting_key: false }
          else
            { parent:, expecting_key: true }
          end
        end

        def close_parent_value(frame)
          close = frame[:close_parent]
          return unless close

          close[:parent][:expecting_key] = close[:expecting_key]
        end
      end
    end

    Registry.register(KeyDuplicates)
  end
end
