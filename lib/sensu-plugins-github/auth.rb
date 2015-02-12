#
# Acquire auth for Github
#
module SensuPluginsGithub
  def self.acquire_git_token
    File.readlines(File.expand_path('~/.ssh/git_token')).each do |line|
      @github_token = line
      puts line
      return line
    end
  end
end
