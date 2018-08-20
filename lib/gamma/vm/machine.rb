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
        puts "======== #{command_method}"
        puts "   -> #{command.payload}"
        send command_method, *command.payload
      end

      def trace?
        true
      end
    end
  end
end
