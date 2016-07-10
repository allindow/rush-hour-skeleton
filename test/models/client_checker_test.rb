require_relative '../test_helper'

class ParserTest < Minitest::Test
  include TestHelpers

  def test_it_returns_200_and_success_if_valid
    params = {"identifier" => 'jumpstartlab', "rootUrl" => 'http://jumpstartlab.com'}

    assert_equal [200, "Success"], ClientChecker.response(params)
  end

  def test_it_returns_403_and_error_message_if_identifier_exists
    Client.create(identifier: 'jumpstartlab', root_url: 'http://jumpstartlab.com')
    params = {"identifier" => 'jumpstartlab', "rootUrl" => 'http://jumpstartlab.com'}

    assert_equal [403, "Identifier Already Exists"], ClientChecker.response(params)
  end

  def test_it_returns_400_missing_parameter_if_identifier_missing
    params = {"rootUrl" => 'http://jumpstartlab.com'}

    assert_equal [400, "Missing Parameters"], ClientChecker.response(params)

  end

  def test_it_returns_400_missing_parameter_if_root_url_missing
    params = {"identifier" => 'jumpstartlab'}

    assert_equal [400, "Missing Parameters"], ClientChecker.response(params)
  end
end
