require_relative '../test_helper'

class ClientSeesAppWelcomePageTest < FeatureTest

  def test_client_sees_welcome_page
    post '/sources', { identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com'}
    post '/sources/jumpstartlab/data', {payload: raw_payload}

    visit '/'

    assert_equal "/sources", current_path
    assert page.find("h1").has_content?("RushHour")
    assert page.find("h4").has_content?("Select your account from the menu above.")
    assert page.has_content?("Client")
  end
end
