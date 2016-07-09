class Client < ActiveRecord::Base
  validates :root_url, presence: true
  validates :identifier, presence: true, uniqueness: true
  has_many :payload_requests
  has_many :request_types, through: :payload_requests
  has_many :urls, through: :payload_requests
  has_many :software_agents, through: :payload_requests
  has_many :resolutions, through: :payload_requests

  def average_response_time
    payload_requests.average(:responded_in).to_i
  end

  def max_response_time
    payload_requests.maximum(:responded_in).to_i
  end

  def min_response_time
    payload_requests.minimum(:responded_in).to_i
  end

  def most_frequent_request_type #test that most freq always come last in the hash
    top_req = request_types.group(:verb).count.sort_by {|usr_agt| usr_agt[-1]}
    top_req.last[0]
  end

  def all_verbs
    # group.count returning hash in different order. sort?
    request_types.group(:verb).count.keys
  end

  def all_urls_most_to_least_requested
    top_urls = urls.group(:address).count.sort_by {|url| url[-1]}
    top_urls.map { |url| url[0]}.reverse
  end

  def all_browsers
    software_agents.pluck(:message).map do |item|
      UserAgent.parse(item).browser
    end.uniq
  end

  def all_os #refactor with browser
    software_agents.pluck(:message).map do |item|
      UserAgent.parse(item).os
    end.uniq
  end

  def all_resolutions
    resolutions.pluck(:width, :height).uniq
  end


  # def self.average_response_time(identifier)
  #   client = Client.where(identifier: identifier).take
  #   client.payload_requests.average(:responded_in).to_i
  # end
  #
  # def self.max_response_time(identifier)
  #   client = Client.where(identifier: identifier).take
  #   client.payload_requests.maximum(:responded_in).to_i
  # end
  #
  # def self.min_response_time(identifier)
  #   client = Client.where(identifier: identifier).take
  #   client.payload_requests.minimum(:responded_in).to_i
  # end
end
