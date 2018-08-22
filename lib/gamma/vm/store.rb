require 'pry'
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

      def merge(other_store)
        raise "Can only merge stores" unless other_store.is_a?(Store)
        Store[
          other_store.entries.merge(entries)
        ]
      end
    end
  end
end
