#
# Issue Api Request
#
module SensuPluginsGithub
  module Api
    # Issue the api request
    #
    # @param [String] resource
    #
    def self.api_request(resource, api, token) #rubocop:disable all
      endpoint = api + resource
      puts endpoint
      puts token
      request = RestClient::Resource.new(endpoint, timeout: 30)
      headers = {}
      headers[:Authorization] = "token #{ token }"
      JSON.parse(request.get(headers), symbolize_names: true)
    rescue RestClient::ResourceNotFound
      warning "Resource not found (or not accessible): #{resource}"
    rescue Errno::ECONNREFUSED
      warning 'Connection refused'
    rescue RestClient::RequestFailed => e
      # #YELLOW Better handle github rate limiting case
      # (with data from e.response.headers)
      warning "Request failed: #{e.inspect}"
    rescue RestClient::RequestTimeout
      warning 'Connection timed out'
    rescue RestClient::Unauthorized
      warning 'Missing or incorrect Github API credentials'
    rescue JSON::ParserError
      warning 'Github API returned invalid JSON'
    end
  end
end
