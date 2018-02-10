class Api::LanguagesController < ApplicationController

  TOKEN = ENV['GITHUB_TOKEN'].freeze

  def index
    puts "Using authorization token: #{TOKEN}..."
    organization = params['organization']
    repos_hash = perform_http_request "https://api.github.com/orgs/#{organization}/repos?type=source"
    all_projects_langs_hash = {}
    repos_hash.each do |repo|
      lang_usage = perform_http_request repo['languages_url']
      index = repo['name']
      all_projects_langs_hash[index] = lang_usage
    end

    langs_to_bytes = {}
    total_bytes = 0
    all_projects_langs_hash.each do |project, langs|
      puts project
      puts langs
      langs.each do |lang, bytes|
        if langs_to_bytes[lang].nil?
          langs_to_bytes[lang] = bytes
        else
          langs_to_bytes[lang] += bytes
        end
        total_bytes += bytes
      end
    end
    langs_to_bytes_sorted = langs_to_bytes.sort_by {|key, value| value}.reverse

    puts "Total bytes: #{total_bytes}"
    langs_to_percentage = {}
    langs_to_bytes_sorted.each do |lang, bytes|
      puts "#{lang} -> #{bytes} bytes"
      percentage = (bytes.to_f / total_bytes.to_f * 100 * 100).floor / 100.0
      puts "Percentage: #{percentage}%"
      langs_to_percentage[lang] = "#{percentage}%"
    end
    render json: langs_to_percentage
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
