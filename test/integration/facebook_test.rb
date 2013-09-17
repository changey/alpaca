require 'test_helper'

#the test to see if the Facebook website can be connected correctly
class ClientTest < StrategyTestCase
  test 'has correct Facebook site' do
    assert_equal 'https://graph.facebook.com', strategy.client.site
  end

  test 'has correct token url' do
    assert_equal '/oauth/access_token', strategy.client.options[:token_url]
  end
end

# the test to test if the call back after Facebook authentication is working
class CallbackUrlTest < StrategyTestCase
  test "returns the default callback url" do
    url_base = 'http://auth.request.com'
    @request.stubs(:url).returns("#{url_base}/some/page")
    strategy.stubs(:script_name).returns('') # as not to depend on Rack env
    assert_equal "#{url_base}/auth/facebook/callback", strategy.callback_url
  end

  test "returns path from callback_path option" do
    @options = { :callback_path => "/auth/FB/done"}
    url_base = 'http://auth.request.com'
    @request.stubs(:url).returns("#{url_base}/page/path")
    strategy.stubs(:script_name).returns('') # as not to depend on Rack env
    assert_equal "#{url_base}/auth/FB/done", strategy.callback_url
  end

  test "returns url from callback_url option" do
    url = 'https://auth.myapp.com/auth/fb/callback'
    @options = { :callback_url => url }
    assert_equal url, strategy.callback_url
  end
end