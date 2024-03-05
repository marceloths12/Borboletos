
# require 'capybara/rspec'

Capybara.javascript_driver = :selenium_chrome_headless
RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
end
