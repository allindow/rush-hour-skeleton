require_relative '../test_helper'

class RushHourTest < Minitest::Test
  include TestHelpers

  def test_that_it_creates_a_client_with_a_unique_identifier_and_a_root_url
    skip
    post '/sources', { identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com'}

    assert_equal 1, Client.count
    assert_equal 200, last_response.status
    assert_equal "Sucess", last_response.body
  end

  def test_that_it_cannot_create_client_without_identifier
    skip
    post '/sources', {rootUrl: 'http://jumpstartlab.com'}

    assert_equal 0, Client.count
    assert_equal 400, last_response.status
    assert_equal "Identifier can't be blank", last_response.body
  end

  def test_that_it_cannot_create_client_without_root_url
    skip
    post '/sources', {identifier: 'jumpstartlab'}

    assert_equal 0, Client.count
    assert_equal 400, last_response.status
    assert_equal "Root url can't be blank", last_response.body
  end

  def test_it_does_not_create_client_with_existing_identifier
    skip
    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com'}
    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com'}

    assert_equal 403, last_response.status
    assert_equal "Identifier Already Exists", last_response.body
  end

  def test_registered_client_can_send_payload_request
    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com'}
    post '/sources/jumpstartlab/data', {"payload"=>
  JSON.parse("{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"),
 "splat"=>[],
 "captures"=>["jumpstartlab"],
 "identifier"=>"jumpstartlab"}
  # "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}".to_json}

    assert_equal 1, PayloadRequest.count
    assert_equal 200, last_response.status
    assert_equal "Success", last_response.body
  end

  def test_bad_request_if_payload_is_missing
    skip
    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com'}
    post "/sources/jumpstartlab/data"

    assert_equal 0, PayloadRequest.count
    assert_equal 400, last_response.status
    assert_equal "Missing Payload", last_response.body
  end

  def test_forbidden_if_payload_already_received
    skip
    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com'}
    post "/sources/jumpstartlab/data", {url: "http://jumpstartlab.com/blog", requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referredBy: "http://jumpstartlab.com", requestType: "GET", userAgent: "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", resolutionWidth: "1920", resolutionHeight: "1280", ip: "63.29.38.211"}
    post "/sources/jumpstartlab/data", {url: "http://jumpstartlab.com/blog", requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referredBy: "http://jumpstartlab.com", requestType: "GET", userAgent: "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", resolutionWidth: "1920", resolutionHeight: "1280", ip: "63.29.38.211"}

    assert_equal 1, PayloadRequest.count
    assert_equal 403, last_response.status
    assert_equal "Already Received Request", last_response.body
  end

  def test_forbidden_if_application_not_registered
    skip
    post "/sources/jumpstartlab/data", {url: "http://jumpstartlab.com/blog", requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referredBy: "http://jumpstartlab.com", requestType: "GET", userAgent: "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", resolutionWidth: "1920", resolutionHeight: "1280", ip: "63.29.38.211"}

    assert_equal 0, PayloadRequest.count
    assert_equal 403, last_response.status
    assert_equal "Application Not Registered", last_response.body
  end

end
