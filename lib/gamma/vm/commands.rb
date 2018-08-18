module Gamma
  module VM
    module Commands
      class Command < Struct.new(:payload)
        def inspect
          "CMD:#{self.class.name.split('::').last}(#{payload.join(',')})"
        end
      end

      # reg
      class PutAnonymousRegister < Command; end
      class StoreDictionaryKey < Command; end
      class RetrieveDictionaryKey < Command; end
      class Copy < Command; end

      # arith
      class Add < Command; end
      class Subtract < Command; end
      class Div < Command; end
      class Mult < Command; end

      # fns
      class CallBuiltin < Command; end
      class DefineFunction < Command; end
      class CallUserDefinedFunction < Command; end
    end
  end
end
