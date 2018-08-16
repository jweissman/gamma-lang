require "readline"
require "paint"

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

    def iggy
      Paint['iggy', 'blue', :bright]
    end

    def greet!
      puts
      puts "  Interactive Gamma Interpreter (#{iggy})"
      puts
      puts "   Welcome!"
      puts
    end

    def farewell
      puts
      puts "   Have a good day!"
      puts
    end

    def prompt
      "#{iggy}> "
    end

    def reply_prefix
      Paint[' -> ', '#eaeaea']
    end

    private

    def readline(interpret:)
      while buf = Readline.readline(prompt, true)
        next if buf.empty?
        begin
          rsp = interpret.call(buf)
        rescue => ex
          puts "(An unexpected error occurred!)"
          # fake error obj?
          rsp = Gamma::VM::Result[nil, "Error! #{ex.message}"]
        end

        if rsp.is_a?(Gamma::VM::Result)
          ret, comment = rsp.to_a
          print(reply_prefix, ret.inspect, " "*(20-ret.inspect.length), "# ", comment, "\n")
        else
          # something went wrong, but...
          puts "---> An unexpected error occurred: #{rsp}"
        end
        # print(reply_prefix, rsp.inspect, "\n")
      end
    end
  end
end
