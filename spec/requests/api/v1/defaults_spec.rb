require 'spec_helper'

describe "Common API methods" do
  let(:user) { create(:user) }
  let(:auth) { {'HTTP_AUTHORIZATION' => basic_auth(user.email, user.password)} }
  let(:bad_auth) { {'HTTP_AUTHORIZATION' => basic_auth(user.email, user.password + "badstuff")} }


  it 'authorization successful' do
    get '/api/v1/ping', {}, auth
    json = JSON.parse(response.body)

    expect(response).to be_success
    expect(json["response"]).to eq("pong")
  end

  it 'unauthorized' do
    get '/api/v1/ping'

    expect(response).to be_unauthorized
  end

  it 'bad authorization' do
    get '/api/v1/ping', {pong: 1}, bad_auth

    expect(response.status).to eq(401)
  end

  it 'ping works' do
    get '/api/v1/ping', {pong: 1}, auth
    json = JSON.parse(response.body)

    expect(response).to be_success
    expect(json["response"]).to eq("1")
  end
end
