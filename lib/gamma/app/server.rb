require 'sinatra'
require 'gamma/lang'
require_relative 'helpers/capture_stdout'

module Gamma
  module App
    class Server < Sinatra::Base
      include CaptureStdout

      get '/' do
        puts 'hi there!'
        @input = ''
        @output = \
          "\n" +
          "<center>Welcome!</center>\n" +
          "\n" +
          "\n" +
          "[&checkmark;] Have fun\n" +
          "[ ] Try stuff\n" +
          "[ ] Learn!" +
          "\n" +
          "\n" +
          "\n" +
          "\n" +
          "<center><span style='color: white'>&gamma;</span>-lang #{Gamma::Lang::VERSION}</center>\n" +
          "";


        erb :index
      end

      get '/gamma.css' do
        sass :gamma
      end

      get '/geval' do
        @input = params['user-input']
        @output = ''
        begin
          @output = with_captured_stdout do
            @result = Gamma::Lang.evaluate(@input).ret_value.inspect
          end
        rescue => ex
          @result = "ERR: #{ex.message}"
        end
        puts "you said #{@input}"
        puts "iggy said #{@result}"
        puts "stdout was '#{@output}'"
        erb :index
      end

      run! if __FILE__==$0
    end
  end
end
