require "readline"

require 'gamma/lang'

module Gamma
  class CLI
    def interact!
      greet!
      readline(
        interpret: ->(inp) { Lang.evaluate(inp) }
      )
      farewell!
    end

    protected

    def greet!
      puts
      puts "  Interactive Gamma Interpreter (iggy)"
      puts
      puts "  welcome!!"
    end

    def farewell
      puts
      puts "   Have a good day!!"
      puts
    end

    def prompt
      'iggy> '
    end

    def reply_prefix
      ' -> '
    end

    private

    def readline(interpret:)
      while buf = Readline.readline(prompt, true)
        begin
          rsp = interpret.call(buf)
        rescue => ex
          puts "(An unexpected error occurred!)"
          # fake error obj?
          rsp = Gamma::VM::Result[nil, "Error! #{ex.message}"]
        end

        print(reply_prefix, rsp.inspect, "\n")
      end
    end
  end
end
