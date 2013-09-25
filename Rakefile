require 'sinatra/activerecord/rake'
require File.expand_path('app', File.dirname(__FILE__))

namespace :candidate do
  desc "eg. candidate:create NAME=\"Bob Bobson\" EMAIL=\"bob@bobsonbob.info\""
  task :create do
    email = ENV['EMAIL'] or raise ArgumentError, "Missing EMAIL=..."
    name  = ENV['NAME'] or raise ArgumentError, "Missing NAME=..."

    # Talk to Heroku
    app = create_heroku_app(email)

    # Add to the local DB
    candidate = Candidate.create(
      :name => name,
      :email => email,
      :url_base => app[:url_base],
      :git => app[:git],
    )

    puts "Done!\n"
    puts "Candidate created with:"
    candidate.attributes.each do |attr,val|
      puts "- #{attr}: #{val}"
    end
  end

  def create_heroku_app(email)
    # Sample output:
    #   Creating rocky-oasis-6969... done, stack is cedar
    #   http://rocky-oasis-6969.herokuapp.com/ | git@heroku.com:rocky-oasis-6969.git
    output = `heroku apps:create`
    puts output
    matches = output.match(/^Creating ([^\.]+)... done.*\n(http[^ ]+) \| (git.*)$/) # "http://ancient-crag-5391.herokuapp.com/ | git@heroku.com:ancient-crag-5391.git"
    raise "Couldn't create Heroku app. Output:\n\n#{output}" if matches.nil? || matches[3].nil?

    app, url_base, git = matches[1..3]
    add_candidate_as_collaborator(matches[1], email)
    {
      :subdomain => app,
      :url_base => url_base,
      :git => git,
    }
  end

  def add_candidate_as_collaborator(app, email)
     output = `heroku sharing:add #{email} --app #{app}`
     (`echo $?`.chomp.to_i == 0) or raise "Heroku sharing of #{app} to #{email} failed."
     puts output
  end
end
