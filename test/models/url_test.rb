require_relative '../test_helper'

class UrlTest < Minitest::Test
  include TestHelpers

  def test_it_can_create_url_instance
    Url.create(address: "http://jumpstartlab.com/blog")

    assert Url.exists?(1)
  end

  def test_it_cannot_create_url_without_address
    url = Url.new(address: "")

    refute url.valid?
  end

  def test_url_relationship_to_payload_requests
    three_relationship_requests
    url = Url.first
    url.payload_requests << PayloadRequest.all.first

    assert url.respond_to?(:payload_requests)
    assert_instance_of PayloadRequest, url.payload_requests.first
  end

  def test_url_relationship_to_request_types
    three_relationship_requests
    url = Url.first
    url.payload_requests << PayloadRequest.all.first

    assert url.respond_to?(:request_types)
    assert_instance_of RequestType, url.request_types.first
  end

  def test_url_relationship_to_referrals
    three_relationship_requests
    url = Url.first
    url.payload_requests << PayloadRequest.all.first

    assert url.respond_to?(:referrals)
    assert_instance_of Referral, url.referrals.first
  end

  def test_url_relationship_to_software_agents
    three_relationship_requests
    url = Url.first
    url.payload_requests << PayloadRequest.all.first

    assert url.respond_to?(:software_agents)
    assert_instance_of SoftwareAgent, url.software_agents.first
  end

  def test_url_response_times
    three_relationship_requests

    url = Url.first

    assert_equal "28, 37", url.all_response_times
  end

  def test_average_response_time_for_url
    three_relationship_requests

    url = Url.first

    assert_equal 32, url.average_response_time
  end

  def test_verbs_used_for_url
    three_relationship_requests

    url = Url.first

    assert_equal "GET, POST", url.all_verbs
  end

  def test_most_popular_referrers
    three_relationship_requests
    five_payload_requests

    url = Url.first
    expected = "www.facebook.com, wwww.google.com, wwww.theonion.com"

    assert_equal expected, url.most_popular_referrers
  end

  def test_three_most_popular_user_agents
    three_relationship_requests
    five_payload_requests

    url = Url.first

    expected = "Chrome + OS X 10.8.2, Safari + Windows XP, Safari + iOs"

    assert_equal expected, url.most_popular_user_agents
  end

  def test_can_get_relative_path
    address = "http://jumpstartlab.com/blog"

    assert_equal "blog", Url.relative_path(address)
  end

  def test_can_get_all_response_times
    three_relationship_requests
    url = Url.find_by(address: 'http://example.com/jasonisnice')

    assert_equal "28, 37", url.all_response_times
  end

  def test_can_get_min_response_time
    three_relationship_requests
    url1 = Url.find_by(address: 'http://example.com/jasonisnice')

    assert_equal 28, url1.min_response_time

    url2 = Url.find_by(address: 'http://example.com/mattisnice')

    assert_equal 42, url2.min_response_time
  end

  def test_can_get_max_response_time
    three_relationship_requests
    url1 = Url.find_by(address:'http://example.com/jasonisnice')

    assert_equal 37, url1.max_response_time

    url2 = Url.find_by(address: 'http://example.com/mattisnice')

    assert_equal 42, url2.max_response_time
  end

  def test_can_get_average_response_time
    three_relationship_requests
    url1 = Url.find_by(address:'http://example.com/jasonisnice')

    assert_equal 32, url1.average_response_time

    url2 = Url.find_by(address: 'http://example.com/mattisnice')

    assert_equal 42, url2.average_response_time
  end

end
