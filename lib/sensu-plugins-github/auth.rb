#
# Acquire auth for Github
#
module SensuPluginsGithub
  module Auth
    def self.acquire_git_token
      File.readlines(File.expand_path('~/.ssh/git_token'))[0]
    end
  end
end
