require 'bundler/setup'
require 'sinatra/base'
require 'haml'
require 'json'
require 'sinatra/activerecord'

require 'rspec'
require 'rspec/core/formatters/json_formatter'

# Load everything in these paths:
%w(
  config/initializers
  models
).each do |path|
  Dir["#{File.dirname(__FILE__)}/#{path}/**/*.rb"].each {|f| require f }
end

class App < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  configure do
    set :views, File.join(File.dirname(__FILE__), '/views')
    set :database, "sqlite3:///db/development.sqlite3"
  end

  get '/' do
    haml :'candidates/index', :locals => {
      :candidates => Candidate.all,
    }
  end

  get '/candidates/:id/tests' do
    candidate = Candidate.find(params[:id])
    haml :'tests/results', :locals => {
      :candidate => candidate,
      :results => spec_run(candidate.url_base),
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

def spec_run(host)
  # So totally not thread-safe.
  unless RSpec.configuration.respond_to?(:target_host)
    RSpec.configure do |c|
      c.add_setting :target_host
    end
  end
  RSpec.configure do |c|
    c.target_host = host
  end
  config = RSpec.configuration
  formatter = RSpec::Core::Formatters::JsonFormatter.new(config.out)
  reporter = RSpec::Core::Reporter.new(formatter)
  config.instance_variable_set(:@reporter, reporter)
  RSpec::Core::Runner.run(['spec'])
  formatter.output_hash
end
