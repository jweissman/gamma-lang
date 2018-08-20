require 'thor'
# require 'filewatcher'
require_relative 'app'
require_relative 'iggy'

module Gamma
  class CLI < Thor
    desc 'server', "launch the server"
    def server
      App::Server.run!
    end

    desc 'iggy', "talk to iggy"
    def iggy
      iggy = Iggy.new
      iggy.interact!
    end

    desc 'exec', "run a gamma file"
    def exec(file)
      program = File.read(file)
      Gamma::Lang.evaluate(program)
    end
  end
end
