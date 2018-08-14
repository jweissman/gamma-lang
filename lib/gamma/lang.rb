require 'parslet'
require_relative 'lang/version'
require_relative 'lang/grammar'
require_relative 'lang/parser'
require_relative 'lang/transform'
require_relative 'lang/codegen'

require_relative 'vm'

require_relative 'lang/interpreter'

module Gamma
  module Lang
    class << self
      def evaluate(str)
        interpreter.evaluate(str)
      end

      private

      def interpreter
        @interpreter ||= Interpreter.new
      end
    end
  end
end
