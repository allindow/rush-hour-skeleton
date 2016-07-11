require_relative '../test_helper'

class ClientCanClickTheirUrlLinkAndGoToUrlShowPageTest < FeatureTest

  def test_client_can_view_url_show_page
    create_one_payload_request

    visit '/sources/yahoo'
    click_link "http://yahoo.com/weather"

    assert_equal "/sources/yahoo/urls/weather", current_path
  end
end
