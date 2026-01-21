# frozen_string_literal: true

require 'yaml'

module Yamlint
  module Rules
    class KeyOrdering < Base
      rule_id 'key-ordering'
      desc 'Enforce alphabetical ordering of keys.'
      defaults({})

      def check(context)
        handler = KeyOrderHandler.new
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
            message: "wrong ordering of key \"#{prob[:key]}\" (should be before \"#{prob[:prev_key]}\")",
            fixable: false
          )
        end
      end

      class KeyOrderHandler < Psych::Handler
        attr_reader :problems
        attr_accessor :parser

        def initialize
          super
          @stack = []
          @problems = []
          @parser = nil
        end

        def start_mapping(*)
          parent = current_mapping_frame
          @stack << {
            type: :mapping,
            keys: [],
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

            if current_keys.any? && value < current_keys.last
              @problems << {
                key: value,
                prev_key: current_keys.last,
                line: mark ? mark.line + 1 : 1,
                column: mark ? mark.column + 1 : 1
              }
            end

            current_keys << value
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

    Registry.register(KeyOrdering)
  end
end
