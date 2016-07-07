require_relative '../test_helper'

class PayloadRequestTest < Minitest::Test
  include TestHelpers

  def test_it_can_convert_payload_string_to_hash
  result = {
    "url"=>"http://jumpstartlab.com/blog",
    "requestedAt"=>"2013-02-16 21:38:28 -0700",
    "respondedIn"=>37,
    "referredBy"=>"http://jumpstartlab.com",
    "requestType"=>"GET",
    "userAgent"=>
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
    "resolutionWidth"=>"1920",
    "resolutionHeight"=>"1280",
    "ip"=>"63.29.38.211"
    }

    assert_equal result, payload
  end

  def test_payload_parser
    assert_equal "http://jumpstartlab.com/blog", payload_parser[:url]
    assert_equal "2013-02-16 21:38:28 -0700", payload_parser[:requested_at]
    assert_equal 37, payload_parser[:responded_in]
    assert_equal "http://jumpstartlab.com", payload_parser[:referral]
    assert_equal "GET", payload_parser[:request_type]
    assert_equal "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", payload_parser[:software_agent]
    assert_equal "1920", payload_parser[:resolution_width]
    assert_equal "1280", payload_parser[:resolution_height]
    assert_equal "63.29.38.211", payload_parser[:ip]
  end

  def test_relationships_of_payload_request #WIP
    payload_request = create_payload
    url = Url.first
    url.payload_requests << payload_request

    # require 'pry'; binding.pry
    refute url.payload_requests.empty?
    # assert_instance_of Resolution, payload_request.resolutions.first
    # assert_instance_of RequestType, payload_request.request_types.first
    # assert_instance_of SoftwareAgent, payload_request.software_agents.first
    # assert_instance_of Ip, payload_request.ips.first
  end

  def test_average_response_time_for_all_requests
    create_faker_payload(2)

    sum_response_time = PayloadRequest.sum(:responded_in)
    average_time = sum_response_time / PayloadRequest.count

    assert_equal 2, PayloadRequest.count
    assert_equal average_time, PayloadRequest.average(:responded_in)
  end

  def test_max_response_time_for_all_requests
    create_faker_payload(2)

    assert_equal , PayloadRequest.maximum(:responded_in)
  end

  def test_min_response_time_for_all_requests
    create_faker_payload(2)

    assert_equal , PayloadRequest.minimum(:responded_in)
  end

  def test_most_frequent_request_type
    create_faker_payload(10)

    assert_equal "GET", RequestType.most_frequent_request
  end

  def test_return_all_verbs_for_request_type
    create_faker_payload(10)

    assert_equal , RequestType.all_verbs
  end

  def test_most_frequest_to_least_for_url
    create_faker_payload(10)

    most = Url.most_frequent
    least = Url.least_frequent

    assert_equal most, Url.most_to_least.first
    assert_equal least, Url.most_to_least.last
  end

  def test_web_browser_breakdown_for_software_agent
    create_faker_payload(10)

    assert_equal , SoftwareAgent.all(:browser)
  end

  def test_os_breakdown_for_software_agent
    create_faker_payload(10)

    assert_equal , SoftwareAgent.all(:os)
  end

  def test_resolution_breakdown_for_resolution
    create_faker_payload(10)
    #for each do ("#{:width} x #{:height}")

    assert_equal , Resolution.all_resolutions
  end


end
