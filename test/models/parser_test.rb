require_relative '../test_helper'

class ParserTest < Minitest::Test
  include TestHelpers

  def test_can_get_correct_hash_format_to_create_payload_request
    expected = {
    "url"=>"http://jumpstartlab.com/blog",
    "requestedAt"=>"2013-02-16 21:38:28 -0700",
    "respondedIn"=>37,
    "referredBy"=>"http://jumpstartlab.com",
    "requestType"=>"GET",
    "userAgent"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
    "resolutionWidth"=>"1920",
    "resolutionHeight"=>"1280",
    "ip"=>"63.29.38.211"
    }

    assert_equal expected, Parser.param_parser("payload" => raw_payload)
  end

  def test_can_parse_the_necessary_attributes_to_create_a_payload
    params = ({"payload" => raw_payload})
    parsed = Parser.parsed_payload(params)

    assert_equal "2013-02-16 21:38:28 -0700", parsed[:requested_at]
    assert_equal 37, parsed[:responded_in]
    assert_equal 1, parsed[:url_id]
    assert Url.exists?(1)
    assert_equal 1, parsed[:ip_id]
    assert Ip.exists?(1)
    assert_equal 1, parsed[:request_type_id]
    assert RequestType.exists?(1)
    assert_equal 1, parsed[:software_agent_id]
    assert SoftwareAgent.exists?(1)
    assert_equal 1, parsed[:resolution_id]
    assert Resolution.exists?(1)
    assert_equal 1, parsed[:referral_id]
    assert Referral.exists?(1)
  end
end
