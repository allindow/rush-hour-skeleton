require_relative '../test_helper'

class PayloadRequestTest < Minitest::Test
  include TestHelpers

  def test_it_can_create_payload_request_instance
    PayloadRequest.create(
    requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 37,
    url_id: 1,
    ip_id: 1,
    request_type_id: 1,
    software_agent_id: 1,
    resolution_id: 1,
    client_id: 1,
    referral_id: 1
    )

    assert PayloadRequest.exists?(1)
  end

  def test_it_cannot_create_payload_request_without_requested_at
    payload = PayloadRequest.create(
              responded_in: 37,
              url_id: 1,
              ip_id: 1,
              request_type_id: 1,
              software_agent_id: 1,
              resolution_id: 1,
              client_id: 1,
              referral_id: 1
              )
    refute payload.valid?
    assert_equal ["Requested at can't be blank"], payload.errors.full_messages
  end

  def test_it_cannot_create_payload_request_without_responded_in
    payload = PayloadRequest.create(
              requested_at: "2013-02-16 21:38:28 -0700",
              url_id: 1,
              ip_id: 1,
              request_type_id: 1,
              software_agent_id: 1,
              resolution_id: 1,
              client_id: 1,
              referral_id: 1
              )

    refute payload.valid?
  end

  def test_it_cannot_create_payload_request_without_url_id
    payload = PayloadRequest.create(
              requested_at: "2013-02-16 21:38:28 -0700",
              responded_in: 37,
              ip_id: 1,
              request_type_id: 1,
              software_agent_id: 1,
              resolution_id: 1,
              client_id: 1,
              referral_id: 1
              )
    refute payload.valid?
  end

  def test_it_cannot_create_payload_request_without_ip_id
    payload = PayloadRequest.create(
              requested_at: "2013-02-16 21:38:28 -0700",
              responded_in: 37,
              url_id: 1,
              request_type_id: 1,
              software_agent_id: 1,
              resolution_id: 1,
              client_id: 1,
              referral_id: 1
              )
    refute payload.valid?
  end

  def test_it_cannot_create_payload_request_without_request_type_id
    payload = PayloadRequest.create(
              requested_at: "2013-02-16 21:38:28 -0700",
              responded_in: 37,
              url_id: 1,
              ip_id: 1,
              software_agent_id: 1,
              resolution_id: 1,
              client_id: 1,
              referral_id: 1
              )
    refute payload.valid?
  end

  def test_it_cannot_create_payload_request_without_software_agent_id
    payload = PayloadRequest.create(
              requested_at: "2013-02-16 21:38:28 -0700",
              responded_in: 37,
              url_id: 1,
              ip_id: 1,
              request_type_id: 1,
              resolution_id: 1,
              client_id: 1,
              referral_id: 1
              )
    refute payload.valid?
  end

  def test_it_cannot_create_payload_request_without_resolution_id
    payload = PayloadRequest.create(
              requested_at: "2013-02-16 21:38:28 -0700",
              responded_in: 37,
              url_id: 1,
              ip_id: 1,
              request_type_id: 1,
              software_agent_id: 1,
              client_id: 1,
              referral_id: 1
              )
    refute payload.valid?
  end


  def test_it_cannot_create_payload_request_without_client_id
    payload = PayloadRequest.create(
              requested_at: "2013-02-16 21:38:28 -0700",
              responded_in: 37,
              url_id: 1,
              ip_id: 1,
              request_type_id: 1,
              software_agent_id: 1,
              resolution_id: 1,
              referral_id: 1
              )
    refute payload.valid?
  end

  def test_average_response_time_for_all_requests
    create_faker_payloads(2)

    sum_response_time = PayloadRequest.sum(:responded_in)
    average_time = (sum_response_time / PayloadRequest.count)
    average_time = average_time

    assert_equal 2, PayloadRequest.count
    assert_equal average_time, PayloadRequest.average(:responded_in).to_i
  end

  def test_max_response_time_for_all_requests
    create_faker_payloads(2)

    max = PayloadRequest.pluck(:responded_in).max

    assert_equal max, PayloadRequest.maximum(:responded_in)
  end

  def test_min_response_time_for_all_requests
    create_faker_payloads(2)

    min = PayloadRequest.pluck(:responded_in).min

    assert_equal min, PayloadRequest.minimum(:responded_in)
  end

  def test_most_frequent_request_type
    three_relationship_requests

    assert_equal "POST", PayloadRequest.most_frequent_request_type
  end

  def test_return_all_verbs_for_request_type
    three_relationship_requests

    assert_equal ["GET","POST"], RequestType.all_verbs_used
  end

  def test_most_frequest_to_least_for_url
    three_relationship_requests

    expected = ["http://example.com/jasonisnice","http://example.com/mattisnice"]
    assert_equal expected, PayloadRequest.url_frequency
  end

  def test_max_response_time_for_all_requests
    three_relationship_requests

    assert_equal 42, PayloadRequest.max_response_time
  end

end
