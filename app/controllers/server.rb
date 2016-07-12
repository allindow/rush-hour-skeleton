module RushHour
  class Server < Sinatra::Base

    not_found do
      erb :error, :layout => false
    end

    get '/' do
      redirect '/sources'
    end

    get '/sources' do
      @clients = Client.all
      erb :welcome
    end

    post '/sources' do
      cv = ClientChecker.response(params)
      status, body = cv
    end

    post "/sources/:identifier/data" do |identifier|
      cv = PayloadChecker.response(identifier, request.params)
      status, body = cv
    end

    get "/sources/:identifier" do |identifier|
      @clients = Client.all
      @identifier = PayloadChecker.confirm_client_account(identifier)
      not_found if @identifier.class == Array
      erb :client_show
    end

    get "/sources/:identifier/urls/:RELATIVEPATH" do |identifier, relativepath|
      @clients = Client.all
      @identifier = PayloadChecker.confirm_client_account(identifier)
      # @relativepath = relativepath
      @client = Client.find_by(identifier: identifier)
      @url = @client.root_url + "/#{relativepath}"
      erb :client_url_show
    end
  end
end
