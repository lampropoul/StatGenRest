require 'spec_helper'

describe 'API testing', type: :request do

  it 'should display message about not being authorized' do
    get '/languages', params: {format: 'json', organization: 'facebook'}
    json = JSON.parse response.body
    expect(json['error']).to eq('No authorization token provided. Visit https://github.com/settings/tokens to get one.')
  end

  it 'should return that no organization provided' do
    get '/languages', params: {format: 'json', organization: ''}, headers: {Authorization: "token #{ENV['GITHUB_TOKEN']}"}
    json = JSON.parse response.body
    expect(json['error']).to eq('No organization provided.')
  end

  it 'should return that provided organization does not exist' do
    get '/languages', params: {format: 'json', organization: 'QwErTy1234567890'}, headers: {Authorization: "token #{ENV['GITHUB_TOKEN']}"}
    json = JSON.parse response.body
    expect(json['error']).to eq('Organization not found.')
  end

  it 'should return 200 OK' do
    get '/languages', params: {format: 'json', organization: 'skroutz'}, headers: {Authorization: "token #{ENV['GITHUB_TOKEN']}"}
    expect(response.status).to eq(200)
  end

end