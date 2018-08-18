module Gamma
  module VM
    class Store < Struct.new(:entries)
      include BuiltinTypes
      def set(key:, value:)
        entries[key.to_sym] = value
        true
      end

      def get(key:)
        entries[key.to_sym] || GNothing[]
      end
    end
  end
end
