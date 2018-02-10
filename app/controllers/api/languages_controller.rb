class Api::LanguagesController < ApplicationController
  include Api::LanguagesHelper

  def index
    @@token = request.headers['Authorization']
    render_error_no_auth_token && return if @@token.nil? || @@token == ''
    puts "Using authorization: #{@@token}..."

    organization = params['organization']
    render_error_no_org_provided && return if organization.nil? || organization == ''

    response = perform_http_request "https://api.github.com/orgs/#{organization}/repos?type=source", @@token
    render_error_not_found && return if response.code == '404' # ORGANIZATION NOT FOUND
    render_error_unauthorized && return if response.code == '401' # UNAUTHORIZED
    repos_hash = JSON.parse response.body

    projects_to_langs = {}
    # iterate over all repos in order to get language stats for each of them
    repos_hash.each do |repo|
      repo_name = repo['name']
      response = perform_http_request repo['languages_url'], @@token
      render_error_unauthorized && return if response.code == '401' # UNAUTHORIZED
      repo_lang_usage = JSON.parse response.body
      projects_to_langs[repo_name] = repo_lang_usage # an entry should be something like {"skroutz.rb" => {"Ruby"=>58462}}
    end

    langs_to_bytes = {}
    all_repos_total_bytes = 0
    projects_to_langs.each do |project, langs|
      puts "#{project} has #{langs}"
      puts '##############################################'
      # iterate over each lang to sum its bytes on all repos
      langs.each do |lang, bytes|
        if langs_to_bytes[lang].nil?
          # if this lang is not in the hash, assign the first value
          langs_to_bytes[lang] = bytes
        else
          # else sum it up
          langs_to_bytes[lang] += bytes
        end
        # sum total bytes from all langs and repos
        all_repos_total_bytes += bytes
      end
    end

    # reverse sort by bytes of each lang in order to have the most used on top
    langs_to_bytes_sorted = langs_to_bytes.sort_by {|lang, bytes| bytes}.reverse

    puts "Total bytes: #{all_repos_total_bytes}"
    langs_to_percentage = {}
    langs_to_bytes_sorted.each do |lang, bytes|
      # convert all bytes to float in order to get a number below 1, then multiply with 100 to get a percentage
      percentage = bytes.to_f / all_repos_total_bytes.to_f * 100
      #  convert to BigDecimal and truncate to 2 decimal digits
      percentage_truncated = percentage.to_d.truncate(2).to_f
      # add to final hash with percentages as strings
      langs_to_percentage[lang] = "#{percentage_truncated}%"
      puts "#{lang} -> #{bytes} bytes (#{percentage_truncated}%)"
    end
    render json: JSON.pretty_generate(langs_to_percentage)
  end

end
