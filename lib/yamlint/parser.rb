# frozen_string_literal: true

module Yamlint
  module Parser
    autoload :LineParser, 'yamlint/parser/line_parser'
    autoload :TokenParser, 'yamlint/parser/token_parser'
    autoload :CommentExtractor, 'yamlint/parser/comment_extractor'
    autoload :Comment, 'yamlint/parser/comment_extractor'
  end
end
