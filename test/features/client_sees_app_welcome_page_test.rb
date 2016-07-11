require_relative '../test_helper'

class ClientSeesAppWelcomePageTest < FeatureTest

  def test_client_url_link_functionality
    post '/sources', { identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com'}
    post '/sources/jumpstartlab/data', {payload: raw_payload}

    visit '/'
    assert_equal "/sources", current_path
    assert page.find("h2").has_content?("RushHour")
    assert page.find("h4").has_content?("Select your account from above")
    assert page.has_content?("Client")
  end
end
