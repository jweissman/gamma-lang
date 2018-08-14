require 'gamma/ext'
module Gamma
  module Lang
    module AST
      class Node < Struct.new(:contents)
        using Gamma::Ext
        def inspect #(depth: 0)
          # tabs = "\t" * depth
          name = self.class.name.demodulize
          "#{name}[#{contents.inspect}]"
        end
      end

      # class Node < Struct.new(:contents, keyword_init: true); end
      class IntLiteral < Node #Struct.new(:val)
      end

      class Operation < Node # Struct.new(:op)
      end

      class Sequence < Node # Struct.new(:seq)
        # def inspect(depth: 0)
        #   tabs = "\t" * depth
        #   inspected_contents = contents.map { |it| it.inspect(depth: depth+2) }.join("\n#{tabs}")
        #   "#{self.class.name.split('::').last}[" +
        #   "\n#{tabs}#{inspected_contents}" +
        #   "\n#{tabs}]"
        # end
      end
    end
  end
end
