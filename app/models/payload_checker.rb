class PayloadChecker

  def self.payload_missing
    "Url can't be blank, Requested at can't be blank, Responded in can't be blank, Request type can't be blank, Resolution can't be blank, Ip can't be blank, Software agent can't be blank, Referral can't be blank"
  end

  def self.nil_client
    [403, "Application Not Registered"]
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
    elsif error_message(client) == payload_missing
      [400, "Missing Payload"]
    elsif error_message(client) == taken_client
      [403, "Already Received Request"]
    end
  end

  def self.response(identifier, params)
    client = Client.find_by(identifier: identifier)
    client.nil?  ? nil_client : responder(client, params)
  end
end
