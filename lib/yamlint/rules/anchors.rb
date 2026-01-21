# frozen_string_literal: true

require 'yaml'

module Yamlint
  module Rules
    class Anchors < Base
      rule_id 'anchors'
      desc 'Check anchors are defined before use and are not duplicated.'
      defaults({
                 'forbid-undeclared-aliases': true,
                 'forbid-duplicated-anchors': true,
                 'forbid-unused-anchors': true
               })

      def check(context)
        handler = AnchorHandler.new
        parser = Psych::Parser.new(handler)
        handler.parser = parser

        begin
          parser.parse(context.content)
        rescue Psych::SyntaxError
          return []
        end

        problems = []

        if @config[:'forbid-undeclared-aliases']
          handler.undeclared_aliases.each do |alias_info|
            problems << problem(
              line: alias_info[:line],
              column: alias_info[:column],
              message: "found undefined alias \"#{alias_info[:name]}\"",
              fixable: false
            )
          end
        end

        if @config[:'forbid-duplicated-anchors']
          handler.duplicated_anchors.each do |anchor_info|
            problems << problem(
              line: anchor_info[:line],
              column: anchor_info[:column],
              message: "found duplicate anchor \"#{anchor_info[:name]}\"",
              fixable: false
            )
          end
        end

        if @config[:'forbid-unused-anchors']
          handler.unused_anchors.each do |anchor_info|
            problems << problem(
              line: anchor_info[:line],
              column: anchor_info[:column],
              message: "found undefined anchor \"#{anchor_info[:name]}\"",
              fixable: false
            )
          end
        end

        problems
      end

      class AnchorHandler < Psych::Handler
        attr_accessor :parser

        def initialize
          super
          @anchors = {}
          @aliases = []
          @parser = nil
        end

        def scalar(_value, anchor, _tag, _plain, _quoted, _style)
          record_anchor(anchor) if anchor
        end

        def start_mapping(anchor, _tag, _implicit, _style)
          record_anchor(anchor) if anchor
        end

        def start_sequence(anchor, _tag, _implicit, _style)
          record_anchor(anchor) if anchor
        end

        def alias(anchor)
          mark = @parser&.mark
          @aliases << {
            name: anchor,
            line: mark ? mark.line + 1 : 1,
            column: mark ? mark.column + 1 : 1
          }
        end

        def undeclared_aliases
          @aliases.reject { |a| @anchors.key?(a[:name]) }
        end

        def duplicated_anchors
          @anchors.values.select { |v| v.is_a?(Array) && v.length > 1 }.flatten
        end

        def unused_anchors
          used_names = @aliases.map { |a| a[:name] }
          @anchors.except(*used_names).map do |_, info|
            info.is_a?(Array) ? info.first : info
          end
        end

        private

        def record_anchor(anchor)
          mark = @parser&.mark
          info = {
            name: anchor,
            line: mark ? mark.line + 1 : 1,
            column: mark ? mark.column + 1 : 1
          }

          if @anchors.key?(anchor)
            existing = @anchors[anchor]
            @anchors[anchor] = existing.is_a?(Array) ? existing + [info] : [existing, info]
          else
            @anchors[anchor] = info
          end
        end
      end
    end

    Registry.register(Anchors)
  end
end
