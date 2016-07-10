require_relative '../test_helper'

class ReferralTest < Minitest::Test
  include TestHelpers
  
  def test_it_can_create_referral_instance
    Referral.create(address: "http://jumpstartlab.com")

    assert Referral.exists?(1)
  end

  def test_cannot_create_referral_without_address
    referral = Referral.new({})

    refute referral.valid?
  end

end
