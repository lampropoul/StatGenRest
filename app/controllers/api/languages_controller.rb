# frozen_string_literal: true

class Api::LanguagesController < ApplicationController
  include Api::LanguagesHelper

  def index
    @@token = request.headers['Authorization']
    render_error_no_auth_token && return if @@token.nil? || @@token == ''
    # puts "Using authorization: #{@@token}..."
    organization = params['organization']
    if organization.nil? || organization == ''
      render_error_no_org_provided
      return
    end
    response = perform_http_request 'https://api.github.com/orgs/'\
                                    "#{organization}/repos?type=source", @@token
    render_error_not_found && return if response.code == :not_found.to_s
    render_error_unauthorized && return if response.code == :unauthorized.to_s
    repos = JSON.parse response.body
    projects_to_langs = {}
    # iterate over all repos in order to get language stats for each of them
    repos.each do |repo|
      repo_name = repo['name']
      response = perform_http_request repo['languages_url'], @@token
      render_error_unauthorized && return if response.code == '401' # UNAUTHORIZED
      repo_lang_usage = JSON.parse response.body
      # an entry should be something like {"skroutz.rb" => {"Ruby"=>58462}}
      projects_to_langs[repo_name] = repo_lang_usage
    end
    langs_bytes = {}
    all_repos_total_bytes = 0
    projects_to_langs.each do |project, languages|
      puts "#{project} has #{languages}"
      puts '##############################################'
      # iterate over each lang to sum its repo_bytes on all repos
      languages.each do |lang, repo_bytes|
        if langs_bytes[lang].nil?
          # if this lang is not in the hash, assign the first value
          langs_bytes[lang] = repo_bytes
        else
          # else sum it up
          langs_bytes[lang] += repo_bytes
        end
        # sum total repo_bytes from all languages and repos
        all_repos_total_bytes += repo_bytes
      end
    end
    # reverse sort by repo_bytes of each lang
    # in order to have the most used on top
    langs_bytes_sorted = langs_bytes.sort_by { |_lang, bytes| bytes }.reverse
    puts "Total repo_bytes: #{all_repos_total_bytes}"
    langs_to_percentage = {}
    langs_bytes_sorted.each do |lang, bytes|
      # convert all repo_bytes to float in order to get a number below 1,
      # then multiply with 100 to get a percentage
      gather(all_repos_total_bytes, bytes, lang, langs_to_percentage)
    end
    render json: JSON.pretty_generate(langs_to_percentage)
  end
end
