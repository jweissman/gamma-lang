module Gamma
  module VM
    class Machine
      include Commands
      using Gamma::Ext

      def manager
        @api ||= API.new(self)
      end

      def handle(command, *args)
        klass = command.class
        name = klass.name.demodulize
        command_method = name.underscore
        puts "=== HANDLE #{command_method} ==="
        send command_method, *command.payload
      end
    end
  end
end
