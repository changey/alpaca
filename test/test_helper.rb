ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'bundler/setup'
require 'minitest/autorun'
require 'mocha_standalone'
require 'omniauth/strategies/facebook'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

# Add more helper methods to be used by all tests here...
  # Add more helper methods to be used by all tests here...
  def login_as(user)
    @request.session[:user_id] = user.id
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end

OmniAuth.config.test_mode = true

module BlockTestHelper
  def test(name, &blk)
    method_name = "test_#{name.gsub(/\s+/, '_')}"
    raise "Method already defined: #{method_name}" if instance_methods.include?(method_name.to_sym)
    define_method method_name, &blk
  end
end

module CustomAssertions
  def assert_has_key(key, hash, msg = nil)
    msg = message(msg) { "Expected #{hash.inspect} to have key #{key.inspect}" }
    assert hash.has_key?(key), msg
  end

  def refute_has_key(key, hash, msg = nil)
    msg = message(msg) { "Expected #{hash.inspect} not to have key #{key.inspect}" }
    refute hash.has_key?(key), msg
  end
end

class TestCase < MiniTest::Unit::TestCase
  extend BlockTestHelper
  include CustomAssertions
end

class StrategyTestCase < TestCase
  def setup
    @request = stub('Request')
    @request.stubs(:params).returns({})
    @request.stubs(:cookies).returns({})
    @request.stubs(:env).returns({})
    @request.stubs(:ssl?).returns(false)

    @client_id = '448228238605607'
    @client_secret = 'c08726b1b7abdeb53a3c498f875ca3f7'
  end

  def strategy
    @strategy ||= begin
      args = [@client_id, @client_secret, @options].compact
      OmniAuth::Strategies::Facebook.new(nil, *args).tap do |strategy|
        strategy.stubs(:request).returns(@request)
      end
    end
  end
end
