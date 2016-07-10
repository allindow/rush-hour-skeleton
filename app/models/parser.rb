class Parser

  def self.param_parser(params)
    JSON.parse(params["payload"])
  end

  def self.parsed_payload(params)
      {requested_at: param_parser(params)['requestedAt'],
      responded_in: param_parser(params)['respondedIn'],
      url_id: Url.find_or_create_by(address: param_parser(params)["url"]).id,
      ip_id: Ip.find_or_create_by(address: param_parser(params)["ip"]).id,
      request_type_id: RequestType.find_or_create_by(verb: param_parser(params)["requestType"]).id,
      software_agent_id: SoftwareAgent.find_or_create_by(message: param_parser(params)["userAgent"]).id,
      resolution_id: Resolution.find_or_create_by(width: param_parser(params)["resolutionWidth"], height: param_parser(params)["resolutionHeight"]).id,
      referral_id: Referral.find_or_create_by(address: param_parser(params)["referredBy"]).id}
  end

end
