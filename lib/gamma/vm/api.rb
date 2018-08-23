require_relative 'command_builder'

module Gamma
  module VM
    class API < Struct.new(:machine)
      include CommandBuilder

      # execute commands
      def run(cmd)
        begin
          run!(cmd)
        end
      end

      # vm helpers
      def builtin?(method)
        VM::Igloo::BUILTIN_METHODS.keys.include?(method.to_sym)
      end

      def defined?(method)
        true
      end

      protected

      def run!(cmd)
        machine.handle(cmd)
      end
    end
  end
end
