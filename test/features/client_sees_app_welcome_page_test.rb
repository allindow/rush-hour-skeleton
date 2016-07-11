require_relative '../test_helper'

class ClientSeesAppWelcomePageTest < FeatureTest

  def test_client_sees_welcome_page
    Client.create(identifier: 'jumpstartlab', root_url: 'http://jumpstartlab.com')

    visit '/'

    assert_equal "/sources", current_path
    assert page.find("h1").has_content?("RushHour")
    assert page.find("h4").has_content?("Select your account from the menu above.")
    assert page.has_content?("Client")
  end
end
