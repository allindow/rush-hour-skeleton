require_relative '../test_helper'

class ParserTest < Minitest::Test
  include TestHelpers

  def test_200_success_response_if_payload_valid
    client = Client.create(identifier: 'jumpstartlab', root_url: 'http://jumpstartlab.com')

    assert_equal [200, "Success"], PayloadChecker.response('jumpstartlab', test_params)
  end

  def test_400_missing_payload_response_if_no_payload
    client = Client.create(identifier: 'jumpstartlab', root_url: 'http://jumpstartlab.com')

    assert_equal [400, "Missing Payload"], PayloadChecker.response('jumpstartlab', {})
  end

  def test_403_already_received_if_payload_is_duplicate
    client = Client.create(identifier: 'jumpstartlab', root_url: 'http://jumpstartlab.com')
    client.payload_requests.create(Parser.parsed_payload(test_params))

    assert_equal [403, "Already Received Request"], PayloadChecker.response('jumpstartlab', test_params)
  end

  def test_returns_client_instance_if_client_confirmed
    Client.create(identifier: 'jumpstartlab', root_url: 'http://jumpstartlab.com')
    client = Client.find(1)

    assert_equal client, PayloadChecker.confirm_client_account('jumpstartlab')
  end

  def test_403_application_not_registered_if_client_not_exist
    assert_equal [403, "Application Not Registered"], PayloadChecker.confirm_client_account('jumpstartlab')
  end

  def test_returns_url_instance_if_url_requested
    client = Client.create(identifier: 'jumpstartlab', root_url: 'http://jumpstartlab.com')
    client.payload_requests.create(Parser.parsed_payload(test_params))
    url = Url.find(1)

    assert_equal url, PayloadChecker.confirm_url_path('jumpstartlab', 'blog')
  end

  def test_403_not_requested_if_url_not_requested
    client = Client.create(identifier: 'jumpstartlab', root_url: 'http://jumpstartlab.com')
    client.payload_requests.create(Parser.parsed_payload(test_params))
    url = Url.find(1)

    assert_equal [403, "Url has not been requested"], PayloadChecker.confirm_url_path('jumpstartlab', 'hamburgers')
  end

end
