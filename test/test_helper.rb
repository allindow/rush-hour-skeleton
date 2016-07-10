require 'simplecov'
SimpleCov.start

ENV["RACK_ENV"] ||= "test"

require 'bundler'
Bundler.require

require File.expand_path("../../config/environment", __FILE__)
require_relative '../app/models/url'
require 'minitest/autorun'
require 'minitest/pride'
require 'capybara/dsl'
require 'database_cleaner'
require 'json'
require 'useragent'
require 'faker'
require 'rack/test'
require 'tilt/erb'

DatabaseCleaner.strategy = :truncation

module TestHelpers
  include Rack::Test::Methods

  def app
    RushHour::Server
  end

  def test_params
    {"payload"=>
      "{\n    \"url\":\"http://jumpstartlab.com/blog\",
      \n    \"requestedAt\":\"2013-02-16 21:38:28 -0700\",\n
      \"respondedIn\":37,\n
      \"referredBy\":\"http://jumpstartlab.com\",\n
      \"requestType\":\"GET\",\n
      \"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\n
      \"resolutionWidth\":\"1920\",\n
      \"resolutionHeight\":\"1280\",\n
      \"ip\":\"63.29.38.211\"\n  }"}

  end

  def raw_payload
    '{
    "url":"http://jumpstartlab.com/blog",
    "requestedAt":"2013-02-16 21:38:28 -0700",
    "respondedIn":37,
    "referredBy":"http://jumpstartlab.com",
    "requestType":"GET",
    "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
    "resolutionWidth":"1920",
    "resolutionHeight":"1280",
    "ip":"63.29.38.211"
  }'
  end

  def create_faker_payloads(n)
    n.times do
      time = Faker::Time.between(2.days.ago, Date.today, :all).to_s
      PayloadRequest.create(
      requested_at: time,
      responded_in: rand(20..50),
      url_id: create_faker_url.id,
      ip_id: create_faker_ip.id,
      request_type_id: create_faker_request_type.id,
      software_agent_id: create_faker_software_agent.id,
      resolution_id: create_faker_resolution.id,
      client_id: Client.create(identifier: rand(1..1000), root_url: rand(1..1000)).id,
      referral_id: create_faker_referral.id
      )
    end
  end

  def create_faker_url
    urls = ['http://example.com/jasonisnice', 'http://example.com/mattisnice', 'http://example.com/weloveangela', 'http://example.com/robertaisnice']
    Url.find_or_create_by(
    address: urls.sample
    )
  end

  def create_faker_ip
    Ip.find_or_create_by(
    address: Faker::Internet.ip_v4_address
    )
  end

  def create_faker_referral
    addresses = []
    address1 = 'http://www.example.com'
    address2 = 'http://www.nba.com'
    address3 = 'http://www.facebook.com'
    address4 = 'http://www.nfl.com'
    address5 = 'http://www.google.com'
    address6 = 'http://www.mlb.com'
    address7 = 'http://www.oddmanout.com'

    addresses.push(address1, address2, address3, address4, address5, address6, address7)

    Referral.find_or_create_by(
      address: addresses.sample
    )
  end

  def create_faker_resolution
    resolutions = [["1280", "800"], ["1020", "640"], ["1520", "1080"]]
    width_height = resolutions.sample
    Resolution.find_or_create_by(
    width: width_height[0],
    height: width_height[1]
    )
  end

  def create_faker_software_agent
    messages = []
    message1 = "Mozilla/5.0 (Macintosh; iOs) AppleWebKit/537.17 (KHTML, like Gecko) Safari/24.0.1309.0 Safari/537.17"
    message2 = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Safari/24.0.1309.0 Safari/537.17"
    message3 = "Mozilla/5.0 (Macintosh; Windows XP) AppleWebKit/537.17 (KHTML, like Gecko) Firefox/24.0.1309.0 Aol/537.17"
    message4 = "Mozilla/5.0 (Macintosh; Linux) AppleWebKit/537.17 (KHTML, like Gecko) Firefox/24.0.1309.0 Firefox/537.17"
    message5 = "Mozilla/5.0 (Macintosh; Windows XP) AppleWebKit/537.17 (KHTML, like Gecko) Firefox/24.0.1309.0 Chrome/537.17"
    messages.push(message1, message2, message3, message4, message5)
    SoftwareAgent.find_or_create_by(
    message: messages.sample
    )
  end

  def create_faker_request_type
    verbs = ["GET", "PUT", "POST", "DELETE"]
    RequestType.find_or_create_by(
    verb: verbs.sample
    )
  end

  def three_relationship_requests
    PayloadRequest.create(
    requested_at: Faker::Time.between(2.days.ago, Date.today, :all).to_s,
    responded_in: 37,
    url_id: Url.find_or_create_by(address: "http://example.com/jasonisnice").id,
    ip_id: create_faker_ip.id,
    request_type_id: RequestType.find_or_create_by(verb: "GET").id,
    software_agent_id: SoftwareAgent.find_or_create_by(message: "Mozilla/5.0 (Macintosh; Windows XP) AppleWebKit/537.17 (KHTML, like Gecko) Firefox/24.0.1309.0 Safari/537.17").id,
    resolution_id: create_faker_resolution.id,
    client_id: Client.find_or_create_by(identifier: 'jumpstartlab', root_url: "http://jumpstartlab.com").id,
    referral_id: Referral.find_or_create_by(address: "wwww.google.com").id
    )
    PayloadRequest.create(
    requested_at: Faker::Time.between(2.days.ago, Date.today, :all).to_s,
    responded_in: 28,
    url_id:  Url.find_or_create_by(address: "http://example.com/jasonisnice").id,
    ip_id: create_faker_ip.id,
    request_type_id: RequestType.find_or_create_by(verb: "POST").id,
    software_agent_id: SoftwareAgent.find_or_create_by(message: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Safari/24.0.1309.0 Chrome/537.17").id,
    resolution_id: create_faker_resolution.id,
    client_id: Client.find_or_create_by(identifier: 'startlab', root_url: "http://jumpstartlab.com").id,
    referral_id: Referral.find_or_create_by(address: "wwww.google.com").id
    )
    PayloadRequest.create(
    requested_at: Faker::Time.between(2.days.ago, Date.today, :all).to_s,
    responded_in: 42,
    url_id: Url.find_or_create_by(address: "http://example.com/mattisnice").id,
    ip_id: create_faker_ip.id,
    request_type_id: RequestType.find_or_create_by(verb: "POST").id,
    software_agent_id: SoftwareAgent.find_or_create_by(message: "Mozilla/5.0 (Macintosh; iOs) AppleWebKit/537.17 (KHTML, like Gecko) Safari/24.0.1309.0 Firefox/537.17").id,
    resolution_id: create_faker_resolution.id,
    client_id: Client.find_or_create_by(identifier: 'jumplab', root_url: "http://jumpstartlab.com").id,
    referral_id: Referral.find_or_create_by(address: "www.facebook.com").id
    )
  end

  def five_payload_requests
    PayloadRequest.create(
    requested_at: Faker::Time.between(2.days.ago, Date.today, :all).to_s,
    responded_in: 37,
    url_id: Url.find_or_create_by(address: "http://example.com/jasonisnice").id,
    ip_id: create_faker_ip.id,
    request_type_id: RequestType.find_or_create_by(verb: "GET").id,
    software_agent_id: SoftwareAgent.find_or_create_by(message: "Mozilla/5.0 (Macintosh; iOs) AppleWebKit/537.17 (KHTML, like Gecko) Safari/24.0.1309.0 Safari/537.17").id,
    resolution_id: Resolution.find_or_create_by(width:"1020", height: "640").id,
    client_id: Client.find_or_create_by(identifier: 'jumplab', root_url: "http://jumpstartlab.com").id,
    referral_id: Referral.find_or_create_by(address: "www.facebook.com").id
    )
    PayloadRequest.create(
    requested_at: Faker::Time.between(2.days.ago, Date.today, :all).to_s,
    responded_in: 28,
    url_id:  Url.find_or_create_by(address: "http://example.com/jasonisnice").id,
    ip_id: create_faker_ip.id,
    request_type_id: RequestType.find_or_create_by(verb: "POST").id,
    software_agent_id: SoftwareAgent.find_or_create_by(message: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Safari/24.0.1309.0 Chrome/537.17").id,
    resolution_id: Resolution.find_or_create_by(width:"1020", height: "640").id,
    client_id: Client.find_or_create_by(identifier: 'startlab', root_url: "http://jumpstartlab.com").id,
    referral_id: Referral.find_or_create_by(address: "wwww.theonion.com").id
    )
    PayloadRequest.create(
    requested_at: Faker::Time.between(2.days.ago, Date.today, :all).to_s,
    responded_in: 42,
    url_id: Url.find_or_create_by(address: "http://example.com/mattisnice").id,
    ip_id: create_faker_ip.id,
    request_type_id: RequestType.find_or_create_by(verb: "POST").id,
    software_agent_id: SoftwareAgent.find_or_create_by(message: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Safari/24.0.1309.0 Firefox/537.17").id,
    resolution_id: Resolution.find_or_create_by(width:"1520", height: "1080").id,
    client_id: Client.find_or_create_by(identifier: 'startlab', root_url: "http://jumpstartlab.com").id,
    referral_id: Referral.find_or_create_by(address: "www.facebook.com").id
    )
    PayloadRequest.create(
    requested_at: Faker::Time.between(2.days.ago, Date.today, :all).to_s,
    responded_in: 60,
    url_id: Url.find_or_create_by(address: "http://example.com/mattisnice").id,
    ip_id: create_faker_ip.id,
    request_type_id: RequestType.find_or_create_by(verb: "POST").id,
    software_agent_id: SoftwareAgent.find_or_create_by(message: "Mozilla/5.0 (Macintosh; Windows XP) AppleWebKit/537.17 (KHTML, like Gecko) Firefox/24.0.1309.0 Safari/537.17").id,
    resolution_id: Resolution.find_or_create_by(width:"1520", height: "1080").id,
    client_id: Client.find_or_create_by(identifier: 'jumplab', root_url: "http://jumpstartlab.com").id,
    referral_id: Referral.find_or_create_by(address: "www.theonion.com").id
    )
    PayloadRequest.create(
    requested_at: Faker::Time.between(2.days.ago, Date.today, :all).to_s,
    responded_in: 20,
    url_id: Url.find_or_create_by(address: "http://example.com/mattisnice").id,
    ip_id: create_faker_ip.id,
    request_type_id: RequestType.find_or_create_by(verb: "POST").id,
    software_agent_id: SoftwareAgent.find_or_create_by(message: "Mozilla/5.0 (Macintosh; Windows XP) AppleWebKit/537.17 (KHTML, like Gecko) Firefox/24.0.1309.0 Chrome/537.17").id,
    resolution_id: Resolution.find_or_create_by(width:"1280", height: "800").id,
    client_id: Client.find_or_create_by(identifier: 'jumplab', root_url: "http://jumpstartlab.com").id,
    referral_id: Referral.find_or_create_by(address: "www.food.com").id
    )
  end

  def eight_payload_requests
    five_payload_requests
    PayloadRequest.create(
    requested_at: Faker::Time.between(2.days.ago, Date.today, :all).to_s,
    responded_in: 20,
    url_id: Url.find_or_create_by(address: "http://example.com/jasonisnice").id,
    ip_id: create_faker_ip.id,
    request_type_id: RequestType.find_or_create_by(verb: "PUT").id,
    software_agent_id: SoftwareAgent.find_or_create_by(message: "Mozilla/5.0 (Macintosh; Windows XP) AppleWebKit/537.17 (KHTML, like Gecko) Firefox/24.0.1309.0 Chrome/537.17").id,
    resolution_id: Resolution.find_or_create_by(width:"1280", height: "800").id,
    client_id: Client.find_or_create_by(identifier: 'jumplab', root_url: "http://jumpstartlab.com").id,
    referral_id: Referral.find_or_create_by(address: "www.food.com").id
    )
    PayloadRequest.create(
    requested_at: Faker::Time.between(2.days.ago, Date.today, :all).to_s,
    responded_in: 20,
    url_id: Url.find_or_create_by(address: "http://example.com/mattisnice").id,
    ip_id: create_faker_ip.id,
    request_type_id: RequestType.find_or_create_by(verb: "POST").id,
    software_agent_id: SoftwareAgent.find_or_create_by(message: "Mozilla/5.0 (Macintosh; Windows XP) AppleWebKit/537.17 (KHTML, like Gecko) Firefox/24.0.1309.0 Chrome/537.17").id,
    resolution_id: Resolution.find_or_create_by(width:"1020", height: "640").id,
    client_id: Client.find_or_create_by(identifier: 'jumplab', root_url: "http://jumpstartlab.com").id,
    referral_id: Referral.find_or_create_by(address: "www.food.com").id
    )
    PayloadRequest.create(
    requested_at: Faker::Time.between(2.days.ago, Date.today, :all).to_s,
    responded_in: 20,
    url_id: Url.find_or_create_by(address: "http://example.com/robertaisnice").id,
    ip_id: create_faker_ip.id,
    request_type_id: RequestType.find_or_create_by(verb: "PUT").id,
    software_agent_id: SoftwareAgent.find_or_create_by(message: "Mozilla/5.0 (Macintosh; Windows XP) AppleWebKit/537.17 (KHTML, like Gecko) Firefox/24.0.1309.0 Chrome/537.17").id,
    resolution_id: Resolution.find_or_create_by(width:"1600", height: "1000").id,
    client_id: Client.find_or_create_by(identifier: 'jumplab', root_url: "http://jumpstartlab.com").id,
    referral_id: Referral.find_or_create_by(address: "www.food.com").id
    )
  end

  def three_software_agents
    SoftwareAgent.create(message: "Mozilla/5.0 (Macintosh; iOS) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
    SoftwareAgent.create(message: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Safari/24.0.1309.0 Safari/537.17")
    SoftwareAgent.create(message: "Mozilla/5.0 (Macintosh; Windows XP) AppleWebKit/537.17 (KHTML, like Gecko) Firefox/24.0.1309.0 Safari/537.17")
  end

  def setup
    DatabaseCleaner.start
    super
  end

  def teardown
    DatabaseCleaner.clean
    super
  end

end

Capybara.app = RushHour::Server
Class FeatureTest < Minitest::Test
  include Capybara::DSL
  include TestHelpers
end
