require_relative '../test_helper'

class RushHourTest < Minitest::Test
  include TestHelpers

  def test_that_it_creates_a_client_with_a_unique_identifier_and_a_root_url
    post '/sources', { identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com'}

    assert_equal 1, Client.count
    assert_equal 200, last_response.status
    assert_equal "Success", last_response.body
  end

  def test_that_it_cannot_create_client_without_identifier
    post '/sources', {rootUrl: 'http://jumpstartlab.com'}

    assert_equal 0, Client.count
    assert_equal 400, last_response.status
    assert_equal "Identifier can't be blank", last_response.body
  end

  def test_that_it_cannot_create_client_without_root_url
    post '/sources', {identifier: 'jumpstartlab'}

    assert_equal 0, Client.count
    assert_equal 400, last_response.status
    assert_equal "Root url can't be blank", last_response.body
  end

  def test_it_does_not_create_client_with_existing_identifier
    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com'}
    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com'}

    assert_equal 403, last_response.status
    assert_equal "Identifier Already Exists", last_response.body
  end

  def test_registered_client_can_send_payload_request
    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com'}
    post '/sources/jumpstartlab/data', {payload: raw_payload}

    assert_equal 1, PayloadRequest.count
    assert_equal 200, last_response.status
    assert_equal "Success", last_response.body
  end

  def test_bad_request_if_payload_is_missing
    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com'}
    post "/sources/jumpstartlab/data"

    assert_equal 0, PayloadRequest.count
    assert_equal 400, last_response.status
    assert_equal "Missing Payload", last_response.body
  end

  def test_forbidden_if_payload_already_received
    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com'}
    post "/sources/jumpstartlab/data", {payload: raw_payload}
    post "/sources/jumpstartlab/data", {payload: raw_payload}

    assert_equal 1, PayloadRequest.count
    assert_equal 403, last_response.status
    assert_equal "Already Received Request", last_response.body
  end

  def test_forbidden_if_application_not_registered
    post "/sources/jumpstartlab/data", {payload: raw_payload}

    assert_equal 0, PayloadRequest.count
    assert_equal 403, last_response.status
    assert_equal "Application Not Registered", last_response.body
  end

  def test_find_client
    skip
    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com'}
    post '/sources/jumpstartlab/data', {payload: raw_payload}
    get "/sources/:identifier"

    require "pry"; binding.pry

    assert_instance_of Client, client.confirm_client_account
  end

  def test_it_finds_url_path #WIP
    skip
    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com'}
    post '/sources/jumpstartlab/data', {payload: raw_payload}
    get '/sources/jumpstartlab/urls/blog'
    ​
    assert_equal 'http://jumpstartlab.com/blog', PayloadChecker.confirm_url_path('jumpstartlab', 'blog')
  end

end
