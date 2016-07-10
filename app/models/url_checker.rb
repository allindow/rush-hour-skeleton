require "net/http"

class UrlChecker

  def self.valid?(url)
    url = URI.parse(url)
    req = Net::HTTP.new(url.host, url.port)
    res = req.request_head(url.path)
    res.code == "404" ? false : true
  end

  def self.content(url)
    if valid?(url)
      valid_url_data(url)
    else
      ["This URL has not been requested. Womp womp."]
    end
  end

  def self.valid_url_data(url)
    url = Url.find_by(address: url)

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
