#! /usr/bin/env ruby
#
#   github-repo-metrics
#
# DESCRIPTION:
#   Interacts with Github API to generate metrics about repo.
#
# OUTPUT:
#   metric data
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: rest-client
#
# USAGE:
#
#
# NOTES:
#
#
# LICENSE:
#   Copyright 2013 Nick Stielau, @nstielau
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/metric/cli'
require 'rest-client'
require 'json'
require 'sensu-plugins-github/auth'

#
# AggregateMetrics
#
class AggregateMetrics < Sensu::Plugin::Metric::CLI::Graphite
  option :api,
         short: '-a URL',
         long: '--api URL',
         description: 'Github API URL',
         default: 'https://api.github.com'

  option :token,
         short: '-t TOKEN',
         long: '--token TOKEN',
         description: 'Github OAuth Token',
         default: SensuPluginsGithub.acquire_git_token

  option :repo,
         short: '-r REPO',
         long: '--repo REPO',
         description: 'Github Repository. Defaults to all visible'

  option :owner,
         short: '-o OWNER',
         long: '--owner OWNER',
         description: 'Github User/Org',
         required: true

  option :timeout,
         short: '-t SECONDS',
         long: '--timeout SECONDS',
         description: 'Sensu API connection timeout in SECONDS',
         proc: proc(&:to_i),
         default: 30

  option :scheme,
         description: 'Metric naming scheme',
         long: '--scheme SCHEME',
         default: 'github'

  option :debug,
         long: '--debug',
         description: 'Verbose output'

  # Build the api request
  #
  # @param [String] repo the repo to get the metrics from him
  # @param [String] subresource
  #
  def repo_api_request(repo, subresource)
    api_request("/repos/#{config[:owner]}/#{repo}/#{subresource}")
  end

  # Issue the api request
  #
  # @param [String] resource
  #
  def api_request(resource) #rubocop:disable all
    endpoint = config[:api] + resource
    request = RestClient::Resource.new(endpoint, timeout: config[:timeout])
    headers = {}
    headers[:Authorization] = "token #{config[:token]}" if config[:token]
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

  # Build an api request to get all repos in an org
  #
  def acquire_org_repos
    api_request("/orgs/#{config[:owner]}/repos?type=sources").map { |r| r[:name] }
  end

  # Main function
  #
  def run #rubocop:disable all
    ([config[:repo] || acquire_org_repos].flatten).each do |repo|
      schema = "#{config[:scheme]}.#{config[:owner]}.#{repo}"
      now = Time.now.to_i
      %w(pulls branches tags contributors languages).each do |resource|
        output "#{schema}.stats.#{resource}", repo_api_request(repo, resource).count, now
      end

      repo_api_request(repo, 'languages').each_pair do |language, line_count|
        output "#{schema}.languages.#{language.downcase}", line_count, now
      end

      repo_api_request(repo, 'contributors').each do |contributor|
        output "#{schema}.contributors.#{contributor[:login]}",
               contributor[:contributions], now
      end
    end

    ok
  end
end
