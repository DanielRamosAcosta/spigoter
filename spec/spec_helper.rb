$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'coveralls'
require 'logging'
require 'rspec/logging_helper'
require "codeclimate-test-reporter"
Coveralls.wear!
CodeClimate::TestReporter.start

# Configure RSpec to capture log messages for each test. The output from the
# logs will be stored in the @log_output variable. It is a StringIO instance.

RSpec.configure do |config|
	include RSpec::LoggingHelper
  	config.capture_log_messages
end

require 'spigoter'