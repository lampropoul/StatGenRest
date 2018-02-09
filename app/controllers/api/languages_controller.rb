class Api::LanguagesController < ApplicationController

  TOKEN = ENV['GITHUB_TOKEN'].freeze

  def index
    puts "Using authorization token: #{TOKEN}..."
    organization = 'skroutz'
    repos_hash = perform_http_request "https://api.github.com/orgs/#{organization}/repos?type=source"
    langs_hash = {}
    repos_hash.each do |repo|
      lang_usage = perform_http_request repo['languages_url']
      index = repo['name']
      langs_hash[index] = lang_usage
    end
    render json: langs_hash
  end

  def perform_http_request(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    request['Authorization'] = "token #{TOKEN}"
    response = http.request(request)
    JSON.parse response.body
  end

end
