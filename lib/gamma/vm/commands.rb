module Gamma
  module VM
    module Commands
      class Command < Struct.new(:payload)
        def inspect
          "CMD:#{self.class.name.split('::').last}(#{payload.join(',')})"
        end
      end

      class StoreDictionaryKey < Command; end
      class RetrieveDictionaryKey < Command; end
      class IncrementDictionaryKey < Command; end

      class PutAnonymousRegister < Command; end
      # class AddInts < Command; end
      # class MultiplyInts < Command; end
      class Add < Command; end
      class Subtract < Command; end
      class Mult < Command; end
      class Div < Command; end
    end
  end
end
