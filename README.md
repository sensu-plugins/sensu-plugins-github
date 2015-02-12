## Sensu-Plugins-github

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-github.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-github)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-github.svg)](http://badge.fury.io/rb/sensu-plugins-github)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-github/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-github)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-github/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-github)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-github.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-github)

## Functionality

**github-repo-metrics**

Interacts with Github API to generate metrics about repo.

## Files
 * bin/github-repo-metrics.rb

## Usage

Your github token must be placed in *~/.ssh/git_token*.  You should not be entring secure items on the commandline.  For the plugin will work be backwards compatible but the ability to specify the token on the commandline will be removed in the **0.1.0** release.

## Installation

Add the public key (if you haven’t already) as a trusted certificate

```
gem cert --add <(curl -Ls https://raw.githubusercontent.com/sensu-plugins/sensu-plugins.github.io/master/certs/sensu-plugins.pem)
gem install sensu-plugins-github -P MediumSecurity
```

You can also download the key from /certs/ within each repository.

#### Rubygems

`gem install sensu-plugins-github`

#### Bundler

Add *sensu-plugins-github* to your Gemfile and run `bundle install` or `bundle update`

#### Chef

Using the Sensu **sensu_gem** LWRP
```
sensu_gem 'sensu-plugins-github' do
  options('--prerelease')
  version '0.0.1.alpha.1'
end
```

Using the Chef **gem_package** resource
```
gem_package 'sensu-plugins-github' do
  options('--prerelease')
  version '0.0.1.alpha.1'
end
```

## Notes

[1]:[https://travis-ci.org/sensu-plugins/sensu-plugins-github]
[2]:[http://badge.fury.io/rb/sensu-plugins-github]
[3]:[https://codeclimate.com/github/sensu-plugins/sensu-plugins-github]
[4]:[https://codeclimate.com/github/sensu-plugins/sensu-plugins-github]
[5]:[https://gemnasium.com/sensu-plugins/sensu-plugins-github]
