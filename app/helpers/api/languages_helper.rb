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

  def render_error
    render json: JSON.pretty_generate(error: 'Unauthorized. Please use valid token.')
  end

end
