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

      def defined?(key)
        # binding.pry
        store.get({ key: key }) != GNothing[]
      end

      protected
      # Magic Register Keys
      ANON_REG_KEY = '_'

      # Messages
      GET_MSG = ->(k,v) { "#{k} is #{v.inspect}" }
      SET_MSG = ->(k,v) { "#{k} is now #{v.inspect}" }

      # Builtins
      BUILTIN_METHODS = {
        puts: ->(*args) do
          args.each { |arg| print arg.inspect; puts }
          GNothing[]
        end
      }


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

      def call_builtin(method_name, arg_registers)
        args = arg_registers.map do |key|
          store.get({ key: key })
        end

        meth = BUILTIN_METHODS[method_name.to_sym]

        Result[
          meth.call(*args),
          "Executed builtin method #{method_name}"
        ]
      end

      def define_function(method_name, arg_list, statements)
        store_dictionary_key(method_name, GFunction[arg_list, statements])

        Result[
          method_name,
          "Defined method #{method_name}"
        ]
      end

      # invoke udf by name, with arg registers in an array
      def call_user_defined_function(method_name, arg_registers)
        meth = store.get({ key: method_name })

        raise "#{method_name} is not a GFunction!" unless meth.is_a?(GFunction)

        arg_values = arg_registers.map do |key|
          store.get({ key: key })
        end

        new_frame_vars = meth.arglist.zip(arg_values)

        #
        # execute meth.statements, with a new context/store that is JUST args
        #
        res = GNothing[]
        with_new_frame do
          # set args
          new_frame_vars.map do |key, val|
            store.set({ key: key, value: val })
          end

          # execute statements
          meth.statements.each do |stmt|
            res = handle(stmt)
          end
        end

        res
      end

      protected

      using Gamma::Ext

      def three_register_op(op, dest, left, right)
        l = retrieve_dictionary_key(left).ret_value
        r = retrieve_dictionary_key(right).ret_value
        if l.is_a?(GInt) && r.is_a?(GInt)
          raise "The universe explodes!" if r.value == 0
          result = apply_op(op, l.value, r.value)
          store_dictionary_key(dest, GInt[result])
        else
          raise "Can only multiply ints together " + \
            "(got #{l.class.name.demodulize} and " + \
            "#{r.class.name.demodulize})"
        end
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
      def store
        current_frame[:store]
        # @store ||= Store.new({})
      end

      def current_frame
        @frame ||= base_frame
      end

      def base_frame
        {
          store: Store.new({})
        }
      end

      def with_new_frame
        old_frame = @frame
        @frame = base_frame
        result = yield
        @frame = old_frame
        result
      end
    end
  end
end
