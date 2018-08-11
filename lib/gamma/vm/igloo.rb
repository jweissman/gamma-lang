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
      # class StoreDictionaryKey < Command; end
      # class RetrieveDictionaryKey < Command; end
      # class IncrementDictionaryKey < Command; end

      class PutAnonymousRegister < Command; end
      class AddInts < Command; end
      class MultiplyInts < Command; end
    end

    class Result < Struct.new(:ret_value, :message)
      def inspect
        "#{ret_value} # => #{message}"
      end
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

      def put_anonymous(val)
        put_anonymous_register(val)
      end

      def put_anonymous!(val)
        run(put_anonymous_register(val))
      end

      # def retrieve(key)
      #   get_command(key)
      # end

      # def retrieve!(key)
      #   run()
      # end

      # def store(key, value)
      #   run(set_command(key, value))
      # end

      # def increment(key)
      #   run(inc_command(key))
      # end

      def add_integers(l, r)
        run(add_ints_command(l, r))
      end

      def multiply_integers(l, r)
        run(multiply_ints_command(l, r))
      end

      def run(cmd)
        begin
          run!(cmd)
        # rescue VM::Error
        end
      end

      protected

      def run!(cmd)
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

      def add_ints_command(left, right)
        AddInts[[left, right]]
      end

      def multiply_ints_command(left, right)
        MultiplyInts[[left, right]]
      end

      def put_anonymous_register(value)
        PutAnonymousRegister[[value]]
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
      # Magic Register Keys
      ANON_REG_KEY = '_'

      # Messages
      GET_MSG = ->(k,v) { "#{k} is #{v}" }
      SET_MSG = ->(k,v) { "#{k} is now #{v}" }



      def put_anonymous_register(val)
        store_dictionary_key(ANON_REG_KEY, val)
        # store.set({ key: ANON_REG_KEY, value: val })
      end

      def retrieve_dictionary_key(key)
        val = store.get({ key: key })
        Result[val, GET_MSG[key, val.to_s]]
      end

      def store_dictionary_key(key, val)
        store.set({ key: key, value: val })
        Result[val, SET_MSG[key, val.to_s]]
      end

      def increment_dictionary_key(key)
        int = store.get({ key: key })
        raise "Can't increment a non-Int" unless int.is_a?(Int)
        store_dictionary_key(key, Int[int.value + 1])
      end

      def add_ints(left, right)
        sum = left.value + right.value
        Result[Int[sum], "#{left} + #{right} = #{sum}"]
      end

      def multiply_ints(left, right)
        product = left.value * right.value
        Result[Int[product], "#{left} * #{right} = #{product}"]
      end

      private
      def store; @store ||= Store.new({}) end
    end
  end
end
