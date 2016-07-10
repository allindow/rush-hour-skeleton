require_relative '../test_helper'

class ClientSeesTheirStatsPageTest < FeatureTest

  def test_client_sees_their_stats_page
    post '/sources', { identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com'}
    post '/sources/jumpstartlab/data', {payload: raw_payload}

    visit '/sources/jumpstartlab'

    assert page.find("h2").has_content?("Jumpstartlab")
    
    assert page.find(".client-stats").has_content?("Average Response Time")
    assert page.find(".client-stats").has_content?("Maximum Response Time")
    assert page.find(".client-stats").has_content?("Minimum Response Time")
    assert page.find(".client-stats").has_content?("Most Frequent Request Type")
    assert page.find(".client-stats").has_content?("All Verbs")
    assert page.find(".client-stats").has_content?("All Browsers")
    assert page.find(".client-stats").has_content?("All Operating Systems")
    assert page.find(".client-stats").has_content?("All Resolutions")

    within('div:nth-child(3)') do
      assert page.has_content?('All URLs')
      assert page.has_content?('http://jumpstartlab.com/blog')
    end
  end
end
