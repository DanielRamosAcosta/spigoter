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

# File activesupport/lib/active_support/core_ext/kernel/reporting.rb, line 50
def silence_stream(stream)
    old_stream = stream.dup
    stream.reopen(RbConfig::CONFIG['host_os'] =~ /mswin|mingw/ ? 'NUL:' : '/dev/null')
    stream.sync = true
    yield
ensure
    stream.reopen(old_stream)
    old_stream.close
end

require 'spigoter'
