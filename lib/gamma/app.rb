require_relative 'app/server'

module Gamma
  module App
    class << self
      def launch!
        @pid = rackup!
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

      def rackup!
        unless pid=fork
          puts pid
          # exec("pwd")
          exec("ruby lib/gamma/app/server.rb")
          exit
        end
        puts "Child: #{pid}"
        pid
      end
    end
  end
end
