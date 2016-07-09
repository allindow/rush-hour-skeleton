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
      RequestMaker.make(identifier, params)
    end
  end
end
