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

$LOAD_PATH.unshift([File.expand_path(File.dirname(__FILE__)), '..', 'lib'].join('/'))
require 'sensu-plugins-github'

class CheckUser2FA < Sensu::Plugin::Check::CLI
  option :api,
         short: '-a URL',
         long: '--api URL',
         description: 'Github API URL',
         default: 'https://api.github.com'

  option :token,
         short: '-t TOKEN',
         long: '--token TOKEN',
         description: 'Github OAuth Token',
         default: SensuPluginsGithub::Auth.acquire_git_token

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
    data = api_request('/rate_limit', @config[:api], @config[:token])

    rate_val = 5000 - data['resources']['core']['remaining'].to_i
    crit_val = config[:crit_threshold].to_i

    if rate_val > 0
      critical("GH api requests are above #{crit_val} for the last hour") if crit_val > rate_val
    end

    ok
  end
end
