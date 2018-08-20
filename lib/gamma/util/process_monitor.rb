require 'filewatcher'
require_relative 'process_manager'

module Gamma
  module Util
    # a tiny wrapper around process/filewatcher which tries to
    # manage pids and kill things cleanly
    class ProcessMonitor < ProcessManager
      def initialize(shell_command:, watch_directory:)
        @shell_command = shell_command
        @watch_directory = watch_directory
      end

      def observe!
        launch!
        filewatcher.watch do |filename, event|
          relaunch!
        end
      end

      protected
      attr_reader :watch_directory

      def filewatcher
        @watcher ||= Filewatcher.new(watch_directory)
      end
    end
  end
end
