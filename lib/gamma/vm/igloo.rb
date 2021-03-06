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
        store_dictionary_key(dst.to_s, store.get({ key: src.to_s }))
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

      def call_builtin(method_name, arg_registers, dst)
        args = arg_registers.map do |key|
          store.get({ key: key })
        end
        meth = BUILTIN_METHODS[method_name.to_sym]
        store_dictionary_key(dst, meth.call(*args))
      end

      def define_function(method_name, arg_list, statements)
        local_binding = current_frame.entries.clone
        fn = GFunction[method_name, arg_list, statements, local_binding]
        store_dictionary_key(method_name, fn)

        Result[
          fn,
          "Defined method #{method_name}"
        ]
      end

      # invoke udf by name, with arg registers in an array
      def call_user_defined_function(method_name, arg_registers, dst)
        meth = store.get({ key: method_name })

        unless meth.is_a?(GFunction)
          raise "#{method_name} is not a GFunction!"
        end

        arg_values = arg_registers.map do |key|
          store.get({ key: key.to_s })
        end

        new_frame_vars = meth.arglist.zip(arg_values)

        res = GNothing[]
        with_new_frame(meth.binding) do
          # set args
          new_frame_vars.map do |key, val|
            store.set({ key: key, value: val })
          end

          # execute statements
          meth.statements.each do |stmt|
            res = handle(stmt)
          end
        end

        store_dictionary_key(dst, res.ret_value)
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
        current_frame
      end

      def current_frame
        @frame ||= base_frame
      end

      def base_frame
        Store.new({})
      end

      def with_new_frame(overrides={})
        old_frame = @frame
        @frame = base_frame.
          merge(old_frame).
          merge(Store.new(overrides))
        result = yield
        @frame = old_frame
        result
      end
    end
  end
end
