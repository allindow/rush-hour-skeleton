class ClientChecker

  def self.response(params)
    client = Client.create(identifier: params["identifier"], root_url: params["rootUrl"])
    if client.save
      [200, "{identifier:#{params["identifier"]}}"]
    elsif client_errors(client) == "Identifier has already been taken"
      [403, "#{client_errors(client)}"]
    else
      [400, "#{client_errors(client)}"]
    end
  end

  def self.client_errors(client)
    client.errors.full_messages.join(', ')
  end

end
