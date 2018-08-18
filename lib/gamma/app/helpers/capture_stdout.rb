module Gamma
  module App
    module CaptureStdout
      def with_captured_stdout
        old_stdout = $stdout
        $stdout = StringIO.new
        yield
        $stdout.string
      ensure
        $stdout = old_stdout
      end
    end
  end
end
