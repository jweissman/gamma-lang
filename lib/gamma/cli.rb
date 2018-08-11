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
        rsp = interpret.call(buf)
        print(reply_prefix, rsp, "\n")
      end
    end
  end
end
