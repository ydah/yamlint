# frozen_string_literal: true

require 'yaml'

module Yamlint
  class Linter
    attr_reader :config

    def initialize(config = nil)
      @config = config || Config.load_default
    end

    def lint(content, filepath: nil)
      context = build_context(content, filepath)

      syntax_problems = check_syntax(content, filepath)
      return syntax_problems unless syntax_problems.empty?

      parse_content(context)

      rules = build_rules
      rules.each do |rule|
        problems = rule.check(context)
        context.problems.concat(Array(problems))
      end

      filter_disabled_problems(context)
    end

    def lint_file(filepath)
      content = File.read(filepath)
      lint(content, filepath:)
    end

    private

    def build_context(content, filepath)
      Models::LintContext.new(
        filepath: filepath || '<string>',
        content:
      )
    end

    def parse_content(context)
      token_parser = Parser::TokenParser.new(context.content)
      context.tokens.concat(token_parser.parse)

      comment_extractor = Parser::CommentExtractor.new(context.content)
      context.comments.concat(comment_extractor.extract)
    end

    def check_syntax(content, _filepath)
      Psych.parse(content)
      []
    rescue Psych::SyntaxError => e
      [Models::Problem.new(
        line: e.line,
        column: e.column,
        rule: 'syntax',
        level: :error,
        message: e.message.sub(/^\([^)]+\): /, ''),
        fixable: false
      )]
    end

    def build_rules
      Rules.load_all

      enabled_rules = []
      Rules::Registry.all.each do |rule_class|
        rule_id = rule_class.id
        next unless @config.rule_enabled?(rule_id)

        rule_config = @config.rule_config(rule_id)
        rule_options = rule_config.is_a?(Hash) ? normalize_options(rule_config) : {}
        enabled_rules << rule_class.new(rule_options)
      end

      enabled_rules
    end

    def normalize_options(options)
      normalized = {}
      options.each do |key, value|
        normalized[key.to_s.tr('_', '-').to_sym] = value
      end
      normalized
    end

    def filter_disabled_problems(context)
      disabled_rules = Set.new
      line_disabled = {}

      context.comments.each do |comment|
        if comment.disable_directive?
          rules = comment.disabled_rules
          if comment.text.include?('disable-line')
            line_disabled[comment.line_number] ||= Set.new
            if rules.empty?
              line_disabled[comment.line_number] = :all
            else
              line_disabled[comment.line_number].merge(rules) unless line_disabled[comment.line_number] == :all
            end
          else
            rules.empty? ? disabled_rules = :all : disabled_rules.merge(rules)
          end
        elsif comment.enable_directive?
          rules = comment.disabled_rules
          if rules.empty?
            disabled_rules = Set.new
          elsif disabled_rules.is_a?(Set)
            disabled_rules.subtract(rules)
          end
        end
      end

      context.problems.reject do |problem|
        next true if disabled_rules == :all
        next true if disabled_rules.include?(problem.rule)

        line_disable = line_disabled[problem.line]
        next true if line_disable == :all
        next true if line_disable&.include?(problem.rule)

        false
      end
    end
  end
end
