#! /usr/bin/env ruby
#
#   check-user-2fa.rb
#
# DESCRIPTION:
#   Interacts with Github API to generate metrics about repo.
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

$:.unshift([File.expand_path(File.dirname(__FILE__)), '..', 'lib'].join('/'))
require 'sensu-plugins-github'

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

  option :exclude,
         short: '-x E',
         long: '--exclude-list EXCLUDE_LIST',
         proc:        proc { |a| a.split(/[,;]\s*/) },
         description: 'List of users to exclude'

  def api_request(resource, api, token) #rubocop:disable all
      endpoint = api + resource
      request = RestClient::Resource.new(endpoint, timeout: 30)
      headers = {}
      headers[:Authorization] = "token #{ token }"
      JSON.parse(request.get(headers), symbolize_names: true)
    rescue RestClient::ResourceNotFound
      CLI::warning "Resource not found (or not accessible): #{resource}"
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

  def run
    # Set the token from the commandline or read it in from a file.  Preference is given towards the later and at some point it may be enforced.
    token = config[:token] || SensuPluginsGithub::Auth::acquire_git_token

    # This is the default url and will be fine for most people, github enterprise customers will have a url based upon the org name and will need to set it at the commandline.
    api_url = config[:api] || 'https://api.github.com'

    # List to hold users who do not have 2FA
    user_list = []

    exclude_list = config[:exclude] || ''

    data = api_request("/orgs/#{config[:org]}/members?filter=2fa_disabled", api_url, token)
    data.each do |d|
      user_list << d[:login] if ! exclude_list.include?(d[:login])
    end
    critical("The following users don't have 2FA enabled: #{ user_list }") if user_list != []
    ok
  end
end
