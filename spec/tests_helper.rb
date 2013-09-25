require 'rspec'
require 'faraday'
require 'faraday_middleware'

def host
  RSpec.configuration.target_host
end

def connection
  Faraday.new(host, :builder => middleware)
end

def middleware
  Faraday::Builder.new do |builder|
    builder.request :json
    builder.response :json #, :content_type => /\bjson$/
    builder.adapter Faraday.default_adapter
  end
end


