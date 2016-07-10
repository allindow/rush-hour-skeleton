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

  def self.confirm_client_account(identifier)
    client = Client.find_by(identifier: identifier)
    if client.nil?
      nil_client
    else
      if client.payload_requests
        Client.where(identifier: identifier).take
      else
        payload_missing
      end
    end
  end

  def self.confirm_url_path(identifier, relative_path)
    client = Client.where(identifier: identifier).take
    client_root = client.root_url
    url = client_root + '/' + relative_path
    url = Url.find_by(address: url)
      if url.nil?
        nil_url
      else
        url
      end
  end



end
