require_relative '../ext'
require_relative 'commands'
require_relative 'api'
require_relative 'builtin_types'
require_relative 'store'
require_relative 'machine'
require_relative 'result'

module Gamma
  module VM
    # machine implementation
    # interactive gamma language object oriented [environment]
    class Igloo < Machine
      include BuiltinTypes

      protected
      # Magic Register Keys
      ANON_REG_KEY = '_'

      # Messages
      GET_MSG = ->(k,v) { "#{k} is #{v.inspect}" }
      SET_MSG = ->(k,v) { "#{k} is now #{v.inspect}" }

      def copy(dst, src)
        store_dictionary_key(dst, store.get({ key: src.to_s }))
      end

      def put_anonymous_register(val)
        store_dictionary_key(ANON_REG_KEY, val)
      end

      def retrieve_dictionary_key(key)
        val = store.get({ key: key })
        Result[val, GET_MSG[key, val]]
      end

      def store_dictionary_key(key, val)
        store.set({ key: key, value: val })
        Result[val, SET_MSG[key, val]]
      end

      def increment_dictionary_key(key)
        int = store.get({ key: key })
        raise "Can't increment a non-Int" unless int.is_a?(GInt)
        store_dictionary_key(key, GInt[int.value + 1])
      end

      def add(dest, left, right)
        three_register_op('+', dest, left, right)
      end

      def subtract(dest, left, right)
        three_register_op('-', dest, left, right)
      end

      def mult(dest, left, right)
        three_register_op('*', dest, left, right)
      end

      def div(dest, left, right)
        three_register_op('/', dest, left, right)
      end

      protected

      def three_register_op(op, dest, left, right)
        l = retrieve_dictionary_key(left).ret_value
        r = retrieve_dictionary_key(right).ret_value
        result = apply_op(op, l.value, r.value)
        store_dictionary_key(dest, GInt[result])
      end

      def apply_op(op, lval, rval)
        case op
        when '+' then lval + rval
        when '-' then lval - rval
        when '*' then lval * rval
        when '/' then lval / rval
        else raise "Implement VM binary operation '#{op}'"
        end
      end

      private
      def store; @store ||= Store.new({}) end
    end
  end
end
