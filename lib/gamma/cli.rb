require 'thor'
# require 'filewatcher'
require_relative 'app'
require_relative 'iggy'

module Gamma
  class CLI < Thor
    # about "gamma is a programming language"
    # desc "command-line interface to Gamma environment"

    desc 'server', "launch the server"
    def server
      # `ruby lib/app/server.rb`
      App::Server.run!
    end

    desc 'iggy', "talk to iggy"
    def iggy
      iggy = Iggy.new
      iggy.interact!
    end
  end
end
