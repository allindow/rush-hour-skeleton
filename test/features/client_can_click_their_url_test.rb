require_relative '../test_helper'

class ClientCanClickOnTheirNameFromTheHomepageAndGetToTheirClientPage < FeatureTest

  def test_client_can_click_on_their_name_from_the_homepage_and_get_to_their_client_page
    Client.create(identifier: 'jumpstartlab', root_url: 'http://jumpstartlab.com')

    visit '/sources'
    page.find('.dropdown a#dLabel').click
    page.find('li a').click

    assert_equal "/sources/jumpstartlab", current_path
  end
end
