require 'gamma/lang'
require 'sinatra'

module Gamma
  module App
    class Server < Sinatra::Base
      get '/' do
        puts 'hi there!'
        erb :index
      end

      get '/gamma.css' do
        sass :gamma
      end

      get '/geval' do
        @input = params['user-input']
        @result = begin
                    Gamma::Lang.evaluate(@input).ret_value.inspect
                  rescue => ex
                    "ERR: #{ex.message}"
                  end
        puts "you said #{@input}"
        puts "iggy said #{@result}"
        erb :index
      end

      run! if __FILE__==$0
    end
  end
end
