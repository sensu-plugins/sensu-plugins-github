#! /usr/bin/env ruby
#
#   check-github-system-status.rb
#
# DESCRIPTION:
#   Interacts with Github Status API to check the system status of Github.com itself.
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

class CheckSystemStatus < Sensu::Plugin::Check::CLI
  option :json,
         short: '-j',
         long: '--json',
         boolean: true,
         default: true,
         description: 'Use json for output'

  def api_request(endpoint)
    request = RestClient::Resource.new(endpoint)
    status_json = JSON.parse(request.get)
    ok status_json if config[:json]
    case status_json['status']
    when 'good'
      ok "GitHub status is #{status_json['status']} at: #{status_json['created_on']}"
    when 'minor'
      warning "GitHub status is #{status_json['status']} at: #{status_json['created_on']}"
    when 'major'
      critical "GitHub status is #{status_json['status']} at: #{status_json['created_on']}"
    else
      unknown "GitHub status is #{status_json['status']} at: #{status_json['created_on']} - #{status_json}"
    end
  rescue RestClient::ResourceNotFound
    warning "Resource not found (or not accessible): #{resource}"
  rescue Errno::ECONNREFUSED
    warning 'Connection refused'
  rescue RestClient::RequestFailed => e
    warning "Request failed: #{e.inspect}"
  rescue RestClient::RequestTimeout
    warning 'Connection timed out'
  rescue JSON::ParserError
    warning 'Github API returned invalid JSON'
  end

  def run
    status_url = 'https://status.github.com/api/status.json'
    api_request(status_url)
  end
end
