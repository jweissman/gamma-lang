module Gamma
  module VM
    class Result < Struct.new(:ret_value, :message)
      def inspect
        "Result[#{ret_value}, '#{message}']"
      end
    end
  end
end
