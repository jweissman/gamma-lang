module Gamma
  module VM
    class Store < Struct.new(:entries)
      def set(key:, value:)
        entries[key.to_sym] = value
        true
      end

      def get(key:)
        entries[key.to_sym]
      end
    end
  end
end
