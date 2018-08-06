require_relative '../ext'

module Gamma
  module VM
    module BuiltinTypes
      String = Struct.new(:text) do
        def to_s; text end
      end

      Int = Struct.new(:value) do
        def to_s; value.to_s end
      end
      # Double = Struct.new(:value)
    end

    class Command < Struct.new(:payload); end
    module Commands
      class StoreDictionaryKey < Command; end
      class RetrieveDictionaryKey < Command; end
      class IncrementDictionaryKey < Command; end
    end
    # class Machine; end
    class Result < Struct.new(:ret_value, :message)
    end

    class Store < Struct.new(:entries)
      def set(key:, value:)
        entries[key] = value
        true
      end

      def get(key:)
        entries[key]
      end
    end

    class API < Struct.new(:machine)
      include Commands

      def retrieve(key)
        run(
          get_command(key)
        )
      end

      def store(key, value)
        run(
          set_command(key, value)
        )
      end

      def increment(key)
        run(
          inc_command(key)
        )
      end

      protected

      def run(cmd)
        machine.handle(cmd)
      end

      private

      def get_command(key)
        RetrieveDictionaryKey[[key]]
      end

      def set_command(key, val)
        StoreDictionaryKey[[key, val]]
      end

      def inc_command(key)
        IncrementDictionaryKey[[key]]
      end
    end

    class Machine
      include Commands
      using Gamma::Ext

      def manager
        API.new(self)
      end

      def handle(command, *args)
        klass = command.class
        name = klass.name.split('::').last
        command_method = name.underscore
        puts "=== HANDLE #{command_method} ==="
        send command_method, *command.payload
      end
    end

    # machine implementation
    # interactive gamma language object oriented [environment]
    class Igloo < Machine
      protected
      GET_MSG = ->(k,v) { "#{k} is #{v}" }
      SET_MSG = ->(k,v) { "#{k} is now #{v}" }

      def retrieve_dictionary_key(key)
        val = store.get({ key: key })
        Result[val, GET_MSG[key, val.to_s]]
      end

      def store_dictionary_key(key, val)
        store.set({ key: key, value: val })
        # "#{key} is set to #{val.to_s}"]
        Result[val, SET_MSG[key, val.to_s]]
      end

      def increment_dictionary_key(key)
        # assume builtin int
        int = store.get({ key: key })
        raise "Can't increment a non-Int" unless int.is_a?(Int)
        store_dictionary_key(key, Int[int.value + 1])
      end

      private
      def store; @store ||= Store.new({}) end
    end
  end
end
