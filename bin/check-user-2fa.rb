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

  def run

    # Set the token from the commandline or read it in from a file.  Preference is given towards the later and at some point it may be enforced.
    token = config[:token] || SensuPluginsGithub::Auth::acquire_git_token

    # This is the default url and will be fine for most people, github enterprise customers will have a url based upon the org name and will need to set it at the commandline.
    api_url = config[:api] || 'https://api.github.com'

    # List to hold users who do not have 2FA
    user_list = []

    data = SensuPluginsGithub::Api::api_request("/orgs/#{config[:org]}/members?filter=2fa_disabled", api_url, config[:token])
    data.each do |d|
      user_list << d[:login] if config[:exclude].include?(d[:login])
    end
    puts user_list
  end
end
