#! /usr/bin/env ruby
#
#   check-github-rate-llimit.rb
#
# DESCRIPTION:
#   Interacts with Github API to check the rate limit of a user.
#
# OUTPUT:
#
# PLATFORMS:
#   All
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: rest-client
#   gem: json
#
# USAGE:
#
#
# NOTES:
#
#
# LICENSE:
#   Copyright 2015 Yieldbot, devops@yieldbot.com
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'rest-client'
require 'json'

class CheckUser2FA < Sensu::Plugin::Check::CLI
  option :api,
         short: '-a URL',
         long: '--api URL',
         description: 'Github API URL'

  option :token,
         short: '-t TOKEN',
         long: '--token TOKEN',
         description: 'Github OAuth Token'

  option :org,
         short: '-o ORG',
         long: '--org ORG',
         description: 'Github Org',
         required: true

  option :crit_threshold,
         short: '-c THRESHOLD',
         long: '--critical THRESHOLD',
         description: 'GH API request threshold',
         required: true

  def api_request(resource, api, token)
    endpoint = api + resource
    request = RestClient::Resource.new(endpoint, timeout: 30)
    headers = {}
    headers[:Authorization] = "token #{token}"
    JSON.parse(request.get(headers))
  rescue RestClient::ResourceNotFound
    warning "Resource not found (or not accessible): #{resource}"
  rescue Errno::ECONNREFUSED
    warning 'Connection refused'
  rescue RestClient::RequestFailed => e
    warning "Request failed: #{e.inspect}"
  rescue RestClient::RequestTimeout
    warning 'Connection timed out'
  rescue RestClient::Unauthorized
    warning 'Missing or incorrect Github API credentials'
  rescue JSON::ParserError
    warning 'Github API returned invalid JSON'
  end

  def run
    # Set the token from the commandline or read it in from a file.  Preference
    # is given towards the later and at some point it may be enforced.
    token = config[:token] || SensuPluginsGithub::Auth.acquire_git_token

    # This is the default url and will be fine for most people,
    # github enterprise customers will have a url based upon the org name and
    # will need to set it at the commandline.
    api_url = config[:api] || 'https://api.github.com'

    data = api_request('/rate_limit', api_url, token)

    rate_val = 5000 - data['resources']['core']['remaining'].to_i
    crit_val = config[:crit_threshold].to_i

    if rate_val > 0
      critical("GH api requests are above #{crit_val} for the last hour") if crit_val > rate_val
    end

    ok
  end
end
