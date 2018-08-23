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

      GFunction = Struct.new(:name, :arglist, :statements, :binding) do
        def inspect
          "#{name}()"
        end
      end
    end
  end
end
