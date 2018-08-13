module Gamma
  module VM
    class Store < Struct.new(:entries)
      def set(key:, value:)
        entries[key] = value
        true
      end

      def get(key:)
        entries[key]
      end
    end
  end
end
