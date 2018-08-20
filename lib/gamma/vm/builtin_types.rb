module Gamma
  module VM
    module BuiltinTypes
      GNothing = Struct.new(:void) do
        def inspect; '(Nothing)' end
      end

      GString = Struct.new(:text) do
        def inspect; text end
      end

      GInt = Struct.new(:value) do
        def inspect
          value.to_s
        end
      end

      GFunction = Struct.new(:arglist, :statements) do
        def inspect
          "(lambda)"
        end
      end
    end
  end
end
