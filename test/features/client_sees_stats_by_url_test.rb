require_relative '../test_helper'

class ClientSeesStatsByUrl < FeatureTest

  def test_client_sees_stats_by_url
    create_one_payload_request

    visit '/sources/yahoo/urls/weather'
    assert page.find(".page-title").has_content?("http://yahoo.com/weather")

    within('.stats') do
      assert page.find('li:nth-child(1)').has_content?("Maximum Response Time")
      assert page.find("li:nth-child(2)").has_content?("Minimum Response Time")
      assert page.find("li:nth-child(3)").has_content?("All Response Times")
      assert page.find("li:nth-child(4)").has_content?("Average Response Time")
      assert page.find("li:nth-child(5)").has_content?("HTTP Verb(s) Used For This URL")
      assert page.find("li:nth-child(6)").has_content?("Three most popular referrers")
      assert page.find("li:nth-child(7)").has_content?("Three most popular user agent")
    end
  end
end
