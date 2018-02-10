require 'net/http'

module Api::LanguagesHelper

  def perform_http_request(url, token)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    request['Authorization'] = token
    http.request(request)
  end

  def render_error_unauthorized
    render json: JSON.pretty_generate(error: 'Unauthorized. Please use valid token.')
  end

  def render_error_not_found
    render(json: JSON.pretty_generate(error: 'Organization not found.'))
  end

  def render_error_no_org_provided
    render(json: JSON.pretty_generate(error: 'No organization provided.'))
  end

  def render_error_no_auth_token
    render(json: JSON.pretty_generate(error: 'No authorization token provided. Visit https://github.com/settings/tokens to get one.'))
  end

end
