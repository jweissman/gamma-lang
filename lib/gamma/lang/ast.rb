module Gamma
  module Lang
    module AST
      class Node < Struct.new(:contents)
        def inspect
          "#{self.class.name.split('::').last}[#{contents.to_s}]"
        end
      end

      # class Node < Struct.new(:contents, keyword_init: true); end
      class IntLiteral < Node #Struct.new(:val)
      end

      class Operation < Node # Struct.new(:op)
      end

      class Sequence < Node # Struct.new(:seq)
      end
    end
  end
end
