require 'tests_helper'

describe "Micro-Blogging API" do

  it "receives DELETE /posts" do
    response = connection.delete '/posts'

    expect(response.status).to eq 200
    expect(response.body).to eq []
  end

  it "receives POST /posts and returns new resource" do
    data = {:post => {:content => "This is a post."}}
    response = connection.post '/posts', data

    expect(response.status).to eq 201
    expect(response.body).to eq data
  end

  it "lists all Posts created thus far" do
    delete_response = connection.delete '/posts'
    expect_okay(delete_response)

    post = {:content => "This is a post."}
    post_response = connection.post '/posts', {:post => post}
    expect_okay(post_response)

    index_response = connection.get '/posts'
    expect_okay(index_response)
    expect(index_response).to eq({:posts => [post]})
  end

  it "doesn't fall prey to dumb SQL injection errors" do
    expect(true).to eq false
  end

  def expect_okay(response)
    expect(response.status).to be >= 200
    expect(response.status).to be < 400
  end
end
