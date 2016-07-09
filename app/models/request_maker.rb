class RequestMaker

  def self.make(identifier, params)
    client = Client.find_by(identifier: identifier)
    payload_data = Parser.new(params).payload_parser
    client.payload_requests.create(payload_data)
  end

end
