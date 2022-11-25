# frozen_string_literal: true

module Yamlint
  module Commands
    class Lint
      class << self
        def call
          new.call
        end
      end

      def call
        runner = Runner.new
        runner.run
      end
    end
  end
end
