class Api::LanguagesController < ApplicationController

  def index
    organization = 'skroutz'
    uri = URI.parse("https://api.github.com/orgs/#{organization}/repos?type=source")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    request['Authorization'] = 'token 107f96bacfa3fe50ba6295cd7a10c8eed7c27007'
    response = http.request(request)
    repos_hash = JSON.parse response.body
    langs_hash = {}
    repos_hash.each do |repo|
      uri = URI.parse(repo['languages_url'])
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)
      request['Authorization'] = 'token 107f96bacfa3fe50ba6295cd7a10c8eed7c27007'
      response = http.request(request)
      lang_usage = JSON.parse response.body
      index = repo['name']
      langs_hash[index] = lang_usage
      # puts "#{repo['name']} --> #{lang_usage}"
    end
    render json: langs_hash
  end

end
