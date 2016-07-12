class Client < ActiveRecord::Base
  validates :root_url, presence: true
  validates :identifier, presence: true
  validates_uniqueness_of :identifier, :scope => :root_url

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

  def most_frequent_request_type
    freq = request_types.group(:verb).count
    top_req = freq.sort_by {|usr_agt| usr_agt}.sort_by(&:last).reverse
    top_req.last[0]
  end

  def all_verbs
    request_types.group(:verb).count.keys.sort.join(", ")
  end

  def all_urls_most_to_least_requested
    top_urls = urls.group(:address).count.sort_by {|url| url[-1]}
    top_urls.map { |url| url[0]}.reverse
  end

  def all_browsers
    software_agents.pluck(:message).map do |item|
      UserAgent.parse(item).browser
    end.uniq.join(", ")
  end

  def all_os
    software_agents.pluck(:message).map do |item|
      UserAgent.parse(item).os
    end.uniq.join(", ")
  end

  def all_resolutions
    resolutions.pluck(:width, :height).uniq.map { |w, h| "#{w} x #{h}"}.join(', ')
  end

  def client_stats_content
    if payload_requests.empty?
      ["Nothing registered for this client"]
    else
      valid_client_data
    end
  end

  def valid_client_data
    [
    "Average Response Time: #{average_response_time}",
    "Maximum Response Time: #{max_response_time}",
    "Minimum Response Time: #{min_response_time}",
    "Most Frequent Request Type: #{most_frequent_request_type}",
    "All Verbs: #{all_verbs}",
    "All Browsers: #{all_browsers}",
    "All Operating Systems: #{all_os}",
    "All Resolutions: #{all_resolutions}"
    ]
  end

  def url_stats_content(path)
    url = urls.find_by(address: path)
    if UrlChecker.valid?(path)
      valid_url_data(url)
    else
      ["This URL has not been requested. Womp womp."]
    end
  end

  def valid_url_data(url)
    [
    "Maximum Response Time: #{url.max_response_time}",
    "Minimum Response Time: #{url.min_response_time}",
    "All Response Times: #{url.all_response_times}",
    "Average Response Time: #{url.average_response_time}",
    "HTTP Verb(s) Used For This URL: #{url.all_verbs}",
    "Three most popular referrers: #{url.most_popular_referrers}",
    "Three most popular user agent: #{url.most_popular_user_agents}"
    ]
  end

end
