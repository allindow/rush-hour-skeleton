module RushHour
  class Server < Sinatra::Base

    not_found do
      erb :error
    end

    post '/sources' do
      cv = ClientChecker.response(params)
      status, body = cv
    end

    post "/sources/:identifier/data" do |identifier|
      cv = PayloadChecker.response(identifier, request.params)
      status, body = cv
    end
  end
end
