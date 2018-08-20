require 'gamma/ext'
module Gamma
  module Lang
    module AST
      class Node < Struct.new(:contents)
        using Gamma::Ext
        def inspect
          name = self.class.name.demodulize
          "#{name}[#{contents.inspect}]"
        end
      end

      class IntLiteral < Node
      end

      class Operation < Node
      end

      class Sequence < Node
      end

      class Ident < Node
      end

      class Assign < Node
      end

      class Funcall < Node
      end

      class FunLiteral < Node
      end
    end
  end
end
