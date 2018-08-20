module Gamma
  module VM
    class Machine
      include Commands
      using Gamma::Ext

      def manager
        @api ||= API.new(self)
      end

      def handle(command)
        klass = command.class
        name = klass.name.demodulize
        command_method = name.underscore
        if debug?
          puts "[#{command_method}]"
        end
        send command_method, *command.payload
      end

      def debug?
        false
      end
    end
  end
end
