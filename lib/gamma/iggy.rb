require "readline"
require "paint"

require 'gamma/lang'

module Gamma
  #
  # interactive gamma interpreter (iggy)
  #
  class Iggy
    PRIMARY = '76395D'  # cosmic
    ACCENT  = '343d3f'  # outer-space
    WARN    = 'fdf039'  # golden fizz
    INFO    = 'eaeaea'  # gallery
    # ERROR
    #
    def debug?; true end

    def interact!
      greet!
      readline(
        interpret: ->(inp) { Lang.evaluate(inp) }
      )
      farewell!
    end

    protected

    def iggy
      Paint['iggy', PRIMARY, :bright]
    end

    def gamma
      Paint['GAMMA', INFO, :bright]
    end

    def greet!
      puts
      puts "  Interactive #{gamma} Interpreter (#{iggy})"
      puts
      puts "  -> Welcome!"
      puts
    end

    def farewell!
      puts
      puts
      puts "   Have a good day!"
      puts
    end

    def prompt
      "#{iggy}> "
    end

    def reply_prefix
      Paint['   ->', INFO]
    end

    private

    def readline(interpret:)
      while buf = Readline.readline(prompt, true)
        next if buf.empty?
        begin
          rsp = interpret.call(buf)
        rescue => ex
          puts Paint["An unexpected error occurred: #{ex.message}", WARN]
          puts ex.backtrace if debug?
          # fake error obj?
          # rsp = "Error! #{ex.message}"
        end

        if rsp.is_a?(Gamma::VM::Result)
          ret, comment = rsp.to_a
          reply = Paint[ret.inspect, PRIMARY, :bright]
          puts("#{reply_prefix} #{reply}")
          puts
          puts('   ' + Paint["#{comment}.", PRIMARY])
          puts
        end
      end
    end
  end
end
