require_relative '../test_helper'

class ClientCanClickTheirUrlLinkAndGoToUrlShowPageTest < FeatureTest

  def test_client_can_view_url_show_page
    post '/sources', { identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com'}
    post '/sources/jumpstartlab/data', {payload: raw_payload}

    visit '/sources/jumpstartlab'
    click_link "http://jumpstartlab.com/blog"

    assert_equal "/sources/jumpstartlab/urls/blog", current_path
  end
end
