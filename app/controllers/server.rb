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

    get "/sources/:identifier" do |identifier|
      @identifier = PayloadChecker.confirm_client_account(identifier)
      # @identifier = (Client.where(identifier: identifier).take)
      @avg_resp_time       = @identifier.average_response_time
      @max_resp_time       = @identifier.max_response_time
      @min_resp_time       = @identifier.min_response_time
      @most_freq_req_type  = @identifier.most_frequent_request_type
      @all_verbs           = @identifier.all_verbs
      @all_urls_ranked     = @identifier.all_urls_most_to_least_requested
      @all_browsers        = @identifier.all_browsers
      @all_os              = @identifier.all_os
      @all_res             = @identifier.all_resolutions

      erb :client_show
    end

    get "/sources/:identifier/urls/:RELATIVEPATH" do |identifier, relativepath|
      @identifier = PayloadChecker.confirm_client_account(identifier)
      @relativepath = relativepath
      erb :client_url_show
    end
  end
end
