# frozen_string_literal: true

require 'bundler/setup'
require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
  enable_coverage :branch
  minimum_coverage 95
end

require 'japin'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
