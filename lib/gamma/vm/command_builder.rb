module Gamma
  module VM
    module CommandBuilder
      def put_anonymous(val)
        put_anonymous_register_command(val)
      end

      def retrieve(key)
        get_command(key)
      end

      def store(key, value)
        set_command(key, value)
      end

      def copy(dst, src)
        copy_command(dst, src)
      end

      def add(dest, left, right)
        add_command(dest, left, right)
      end

      def sub(dest, left, right)
        subtract_command(dest, left, right)
      end

      def mult(dest, left, right)
        mult_command(dest, left, right)
      end

      def div(dest, left, right)
        div_command(dest, left, right)
      end

      def call_builtin(method, arglist)
        call_builtin_command(method, arglist)
      end

      def defun(method, arglist, statements)
        define_function_command(method, arglist, statements)
      end

      def call_udf(method, arglist)
        call_user_defined_function_command(method, arglist)
      end


      private
      include Commands

      def get_command(key)
        RetrieveDictionaryKey[[key]]
      end

      def set_command(key, val)
        StoreDictionaryKey[[key, val]]
      end

      def inc_command(key)
        IncrementDictionaryKey[[key]]
      end

      def add_command(dst, left, right)
        Add[[dst, left, right]]
      end

      def subtract_command(dst, left, right)
        Subtract[[dst, left, right]]
      end

      def mult_command(dst, left, right)
        Mult[[dst, left, right]]
      end

      def div_command(dst, left, right)
        Div[[dst, left, right]]
      end

      def put_anonymous_register_command(value)
        PutAnonymousRegister[[value]]
      end

      def copy_command(dst, src)
        Copy[[dst, src]]
      end

      def call_builtin_command(method, arglist)
        CallBuiltin[[method, arglist]]
      end

      def define_function_command(method, arglist, statements)
        DefineFunction[[method, arglist, statements]]
      end

      def call_user_defined_function_command(method, arglist)
        CallUserDefinedFunction[[method, arglist]]
      end
    end
  end
end
