# Change Log

This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]

### Breaking Change

- The github-repo-metrics plugin has been renamed to metrics-github-repo to match other plugins and what was written in the readme
- The metrics plugin now properly loads the Auth module and handles reading the local token

## [3.0.0] - 2017-07-11

### Added

- Testing for Ruby 2.4.1 (@thomasriley)

  ### Breaking Changes

- Bump sensu-plugin runtime dependency to 2.0 for Ruby 2.4.1 support (@thomasriley)

## [2.0.0] - 2016-04-26

### Removed

- support for Rubies 1.0.3 and 2.0

### Added

- support for Ruby 2.3.0

### Changed

- Check github status inside json

## [1.1.0] - 2015-09-10

### Added

- check-github-system-status for checking the status of github itself

## [1.0.0] - 2015-08-14

### Added

- check-github-rate-limit.rb for checking the rate limit of a user

### Changed

- updated documentation urls
- general gem cleanup
- changed the name of _github-repo-metrics_ to _metrics-github-repo_ to keep with convention

### Fixed

- set binstubs to only be created for Ruby binaries

## [0.0.5] - 2015-07-14

### Changed

- updated sensu-plugin gem to 1.2.0

### Removed

- Remove JSON gem dep that is not longer needed with Ruby 1.9+

## [0.0.4] - 2015-06-02

### Added

- check-user-2fa.rb

  - Check to alert upon org users that do not have 2FA enabled

### Fixed

- added binstubs

### Changed

- removed cruft from /lib

## [0.0.3] - 2015-04-02

## [0.0.2] - 2015-02-12

## 0.0.1 - 2015-02-11

[unreleased]: https://github.com/sensu-plugins/sensu-plugins-github/compare/3.0.0...HEAD
[3.0.0]: https://github.com/sensu-plugins/sensu-plugins-github/compare/2.0.0...3.0.0
[2.0.0]: https://github.com/sensu-plugins/sensu-plugins-github/compare/1.1.0...2.0.0
[1.1.0]: https://github.com/sensu-plugins/sensu-plugins-github/compare/1.0.0...1.1.0
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-github/compare/0.0.5...1.0.0
[0.0.5]: https://github.com/sensu-plugins/sensu-plugins-github/compare/0.0.4...0.0.5
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-github/compare/0.0.3...0.0.4
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-github/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-github/compare/0.0.1...0.0.2