module Gamma
  module VM
    class API < Struct.new(:machine)
      include Commands

      def put_anonymous(val)
        put_anonymous_register_command(val)
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

      def mult(dest, left, right)
        mult_command(dest, left, right)
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

      def mult_command(dst, left, right)
        Mult[[dst, left, right]]
      end

      def put_anonymous_register_command(value)
        PutAnonymousRegister[[value]]
      end
    end
  end
end
