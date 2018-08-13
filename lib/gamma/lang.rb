require 'parslet'
require_relative 'vm'
require_relative 'lang/grammar'
require_relative 'lang/parser'
require_relative 'lang/transform'
require_relative 'lang/interpreter'
require_relative 'lang/version'

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
