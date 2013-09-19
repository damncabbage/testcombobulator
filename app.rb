require 'bundler/setup'
require 'sinatra/base'
require 'haml'
require 'json'
require 'rspec'
require 'rspec/core/formatters/json_formatter'

class App < Sinatra::Base
  configure do
    set :views, File.join(File.dirname(__FILE__), '/views')
  end

  get '/' do
    haml :'candidates/index'
  end

  get '/candidates/1/tests' do
    candidate = {:id => 1, :name => "Fred Fredson", :host => 'http://localhost:9292'}
    haml :'tests/results', :locals => {
      :candidate => candidate,
      :results => spec_run(candidate[:host]),
    }
  end

  # Stub end-points for testing against ourselves

  delete '/posts' do
    [].to_json
  end

  get '/posts' do
    halt 404, "what what"
  end

  post '/posts' do
    halt 500, "how i shot web"
  end
end

RSpec.configure do |c|
  c.add_setting :target_host
end

def spec_run(host)
  # So totally not thread-safe.
  RSpec.configure do |c|
    c.target_host = host
  end
  config = RSpec.configuration
  #formatter = RSpec::Core::Formatters::DocumentationFormatter.new(config.out)
  formatter = RSpec::Core::Formatters::JsonFormatter.new(config.out)
  reporter = RSpec::Core::Reporter.new(formatter)
  config.instance_variable_set(:@reporter, reporter)
  RSpec::Core::Runner.run(['spec'])
  formatter.output_hash
end
