require 'rubygems'
require 'rspec'
require 'imagga_auto_tag'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

RSpec.configure do |c|
  c.mock_with :rspec
end