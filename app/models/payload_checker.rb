class PayloadChecker

  def self.payload_missing
    [400, "Missing Payload"]
  end

  def self.nil_client
    [403, "Application Not Registered"]
  end

  def self.nil_url
      [403, "Url has not been requested"]
    end

  def self.error_message(client)
    client.errors.full_messages.join(", ")
  end

  def self.taken_client
    "Client has already been taken"
  end

  def self.responder(client, params)
    payload_data = Parser.parsed_payload(params)
    client = client.payload_requests.create(payload_data)
    if client.save
      [200, "Success"]
    else error_message(client) == taken_client
      [403, "Already Received Request"]
    end
  end

  def self.response(identifier, params)
    client = Client.find_by(identifier: identifier)
    if params.empty?
      payload_missing
    elsif client.nil?
      nil_client
    else
      responder(client, params)
    end
  end

  def self.client_responder(client, identifier)
    if client.payload_requests
      Client.where(identifier: identifier).take
    else
      payload_missing
    end
  end

  def self.client_content(client)
    if client.payload_requests.empty?
      client_no_payload
    else
      valid_client_data(client)
    end
  end

  def self.client_no_payload
    ["Nothing registered for this client"]
  end

  def self.valid_client_data(client)
    [
    "Average Response Time: #{client.average_response_time}",
    "Maximum Response Time: #{client.max_response_time}",
    "Minimum Response Time: #{client.min_response_time}",
    "Most Frequent Request Type: #{client.most_frequent_request_type}",
    "All Verbs: #{client.all_verbs}",
    "All Browsers: #{client.all_browsers}",
    "All Operating Systems: #{client.all_os}",
    "All Resolutions: #{client.all_resolutions}"
    ]
  end

  #
  # @avg_resp_time       = @identifier.average_response_time
  # @max_resp_time       = @identifier.max_response_time
  # @min_resp_time       = @identifier.min_response_time
  # @most_freq_req_type  = @identifier.most_frequent_request_type
  # @all_verbs           = @identifier.all_verbs
  # @all_urls_ranked     = @identifier.all_urls_most_to_least_requested
  # @all_browsers        = @identifier.all_browsers
  # @all_os              = @identifier.all_os
  # @all_res             = @identifier.all_resolutions



  def self.confirm_client_account(identifier)
    client = Client.find_by(identifier: identifier)
    if client.nil?
      nil_client
    else
      client_responder(client, identifier)
    end
  end

  def self.url_response(url)
    if url.nil?
      nil_url
    else
      url.address
    end
  end

  def self.confirm_url_path(identifier, relative_path)
    client = Client.where(identifier: identifier).take
    client_root = client.root_url
    url = client_root + '/' + relative_path
    url = Url.find_by(address: url)
    url_response(url)
  end

end
