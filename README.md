## Sensu-Plugins-github

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-github.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-github)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-github.svg)](http://badge.fury.io/rb/sensu-plugins-github)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-github/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-github)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-github/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-github)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-github.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-github)
[ ![Codeship Status for sensu-plugins/sensu-plugins-github](https://codeship.com/projects/107b69f0-cabf-0132-6fa6-22c60209e864/status?branch=master)](https://codeship.com/projects/75587)

## Functionality

**github-repo-metrics**

Interacts with Github API to generate metrics about repo.

## Files
 * bin/github-repo-metrics.rb

## Usage

Your github token must be placed in *~/.ssh/git_token*, you should not be entring secure items on the commandline.  The plugin will continue to be backwards compatible for a period but the ability to specify the token on the commandline will be removed in the **0.1.0** release.

## Installation

[Installation and Setup](https://github.com/sensu-plugins/documentation/blob/master/user_docs/installation_instructions.md)

## Notes
