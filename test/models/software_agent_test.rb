require_relative '../test_helper'

class SoftwareAgentTest < Minitest::Test
  include TestHelpers

  def test_it_can_create_software_agent_instance
    message = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17"
    SoftwareAgent.create(message: message)

    assert SoftwareAgent.exists?(1)
  end

  def test_software_agent_relationship_to_payload_requests
    three_relationship_requests
    software_agent = SoftwareAgent.first
    software_agent.payload_requests << PayloadRequest.all.first

    assert software_agent.respond_to?(:payload_requests)
    assert_instance_of PayloadRequest, software_agent.payload_requests.first
  end

  def test_it_cannot_create_software_agent_without_message
    agent = SoftwareAgent.new({})

    refute agent.valid?
  end

  def test_web_browser_breakdown_for_software_agent
    three_software_agents

    assert_equal ["Chrome", "Safari", "Safari"], SoftwareAgent.all_browsers_used
  end

  def test_os_breakdown_for_software_agent
    three_software_agents

    assert_equal ["iOS", "OS X 10.8.2", "Windows XP"], SoftwareAgent.all_os_used
  end

end
