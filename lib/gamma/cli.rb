require "readline"

require 'gamma/lang'

module Gamma
  class CLI
    PROMPT = ' > '
    REPLY  = ' -> '

    def greet!
      puts
      puts "  Interactive Gamma Interpreter (iggy)"
      puts
    end

    def interact!
      greet!
      interpreter = Gamma::Lang::Interpreter.new
      while buf = Readline.readline("> ", true)
        rsp = interpreter.evaluate(buf)
        print("-> ", rsp, "\n")
      end
    end
  end
end
