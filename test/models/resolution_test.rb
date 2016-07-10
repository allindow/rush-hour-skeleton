require_relative '../test_helper'

class ResolutionTest < Minitest::Test
  include TestHelpers

  def test_it_can_create_resolution_instance
    Resolution.create(width: "1920", height: "1280")

    assert Resolution.exists?(1)
  end

  def test_resolution_relationship_to_payload_requests
    three_relationship_requests
    resolution = Resolution.first
    resolution.payload_requests << PayloadRequest.all.first

    assert resolution.respond_to?(:payload_requests)
    assert_instance_of PayloadRequest, resolution.payload_requests.first
  end

  def test_it_cannot_create_resolution_without_width
    resolution = Resolution.new(height: "1280")

    refute resolution.valid?
  end

  def test_it_cannot_create_resolution_without_height
    resolution = Resolution.new(width: "640")

    refute resolution.valid?
  end

  def test_resolution_breakdown_for_resolution
    20.times do
      create_faker_resolution
    end
    options = ["(1520 x 1080)", "(1280 x 800)", "(1020 x 640)"]
    assert_equal options, Resolution.all_resolutions_used.max(3)
  end

end
