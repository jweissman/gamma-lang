module Gamma
  module VM
    class API < Struct.new(:machine)
      include Commands

      def builtin?(method)
        VM::Igloo::BUILTIN_METHODS.keys.include?(method.to_sym)
      end

      def call_builtin(method, arglist)
        call_builtin_command(method, arglist)
      end

      def put_anonymous(val)
        put_anonymous_register_command(val)
      end

      def copy(dst, src)
        copy_command(dst, src)
      end

      def retrieve(key)
        get_command(key)
      end

      def store(key, value)
        set_command(key, value)
      end

      def increment(key)
        inc_command(key)
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
    end
  end
end
