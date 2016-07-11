require_relative '../test_helper'

class ClientCanClickOnTheirNameFromTheHomepageAndGetToTheirClientPage < FeatureTest

  def test_client_can_click_on_their_name_from_the_homepage_and_get_to_their_client_page
    post '/sources', { identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com'}
    post '/sources/jumpstartlab/data', {payload: raw_payload}

    visit '/sources'
    page.find('.dropdown a#dLabel').click
    page.find('li a').click

    assert_equal "/sources/jumpstartlab", current_path
  end
end
