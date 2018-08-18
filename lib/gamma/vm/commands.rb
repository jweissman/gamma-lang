module Gamma
  module VM
    module Commands
      class Command < Struct.new(:payload)
        def inspect
          "CMD:#{self.class.name.split('::').last}(#{payload.join(',')})"
        end
      end

      class Add < Command; end
      class CallBuiltin < Command; end
      class Copy < Command; end
      class Div < Command; end
      class IncrementDictionaryKey < Command; end
      class Mult < Command; end
      class PutAnonymousRegister < Command; end
      class RetrieveDictionaryKey < Command; end
      class StoreDictionaryKey < Command; end
      class Subtract < Command; end
    end
  end
end
