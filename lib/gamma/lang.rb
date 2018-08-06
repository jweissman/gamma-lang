require 'parslet'
require_relative 'lang/grammar'
require_relative 'lang/parser'
require_relative 'vm'

module Gamma
  module Lang
    class Interpreter
      def evaluate(inp)
        inp
        # parse commands and hand to vm?
      end
    end
    
    # module Internals
    # class Parser; end
    # class Transform; end
    # module AST; end
    # end
  end
end
