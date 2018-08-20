module Gamma
  module Util
    class ProcessManager
      def initialize(shell_command:)
        @shell_command = shell_command
      end

      def launch!
        @pid = run!
        puts "---> Racked up with pid #@pid"
      end

      def relaunch!
        kill!
        sleep 0.1
        launch!
      end

      def kill!
        puts "---> Would kill #@pid"
        Process.kill('KILL', @pid)
        puts "killed"
      end

      private

      def run!
        unless pid=fork
          puts pid
          exec(@shell_command)
          exit
        end
        puts "Child: #{pid}"
        pid
      end
    end
  end
end
