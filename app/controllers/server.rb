module RushHour
  class Server < Sinatra::Base

    not_found do
      erb :error
    end

    post '/sources' do
      require "pry"; binding.pry
      cv = ClientChecker.response(params)
      status, body = cv
    end

    post "/sources/:identifier/data" do |identifier|
      require "pry"; binding.pry
      params = Parser.parsed_payload(params)
      cv = PayloadChecker.response(identifier, params)
      status, body = cv
    end
  end
end
