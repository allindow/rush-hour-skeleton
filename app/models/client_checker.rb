class ClientChecker

  def self.response(params)
    client = Client.create(identifier: params["identifier"], root_url: params["rootUrl"])
    if client.save
      [200, "Sucess"]
    elsif client.errors.full_messages.join(', ') == "Identifier has already been taken"
      [403, 'Identifier Already Exists']
    else
      [400, client.errors.full_messages.join(', ')]
    end
  end

end
