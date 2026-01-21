# frozen_string_literal: true

module Yamlint
  module TestHelpers
    def build_context(content, filepath: 'test.yaml')
      context = Models::LintContext.new(filepath:, content:)
      token_parser = Parser::TokenParser.new(content)
      context.tokens.concat(token_parser.parse)
      comment_extractor = Parser::CommentExtractor.new(content)
      context.comments.concat(comment_extractor.extract)
      context
    end

    def default_config
      Config.new_with_preset('default')
    end

    def relaxed_config
      Config.new_with_preset('relaxed')
    end
  end
end

RSpec.configure do |config|
  config.include Yamlint::TestHelpers
end
