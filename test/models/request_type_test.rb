require_relative '../test_helper'

class RequestTypeTest < Minitest::Test
  include TestHelpers

  def test_it_can_create_request_type_instance
    RequestType.create(verb: "GET")

    assert RequestType.exists?(1)
  end

  def test_request_type_relationship_to_payload_requests
    three_relationship_requests
    request_type = RequestType.first
    request_type.payload_requests << PayloadRequest.all.first

    assert request_type.respond_to?(:payload_requests)
    assert_instance_of PayloadRequest, request_type.payload_requests.first
  end

  def test_cannot_create_request_type_without_verb
    request = RequestType.new({})

    refute request.valid?
  end

end
