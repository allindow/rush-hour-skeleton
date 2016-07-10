require_relative '../test_helper'

class UrlTest < Minitest::Test
  include TestHelpers

  def test_check_if_url_valid
    refute UrlChecker.valid?("http://www.jumpstartlab.com/apply")
    assert UrlChecker.valid?("http://www.google.com/about")
  end

end
