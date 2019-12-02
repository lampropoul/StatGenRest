require 'net/http'

module Api::LanguagesHelper

  def perform_http_request(url, token)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    request[:Authorization] = token
    http.request(request)
  end

  def render_error_unauthorized
    render json: JSON.pretty_generate(error: 'Invalid token provided.'),
           status: :unauthorized
  end

  def render_error_not_found
    render json: JSON.pretty_generate(error: 'Organization not found.'),
           status: :not_found
  end

  def render_error_no_org_provided
    render json: JSON.pretty_generate(error: 'No organization provided.'),
           status: :bad_request
  end

  def render_error_no_auth_token
    error_descr = 'No authorization token provided. '\
            'Visit https://github.com/settings/tokens to get one.'
    render json: JSON.pretty_generate(error: error_descr),
           status: :unauthorized
  end

  def gather(all_repos_total_bytes, bytes, lang, langs_to_percentage)
    percentage = bytes.to_f / all_repos_total_bytes.to_f * 100
    #  convert to BigDecimal and truncate to 2 decimal digits
    percentage_truncated = percentage.to_d.truncate(2).to_f
    # add to final hash with percentages as strings
    langs_to_percentage[lang] = "#{percentage_truncated}%"
    puts "#{lang} -> #{bytes} bytes (#{percentage_truncated}%)"
  end

end
