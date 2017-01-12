$:.unshift File.join(File.dirname(__FILE__), "lib")

require 'rspec/core/rake_task'
require 'imagga_auto_tag/version'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
task :release do
  puts "=> TravisCI handles the release. So this task will create a tag and push it"
  `git pull --tags`

  version = ImaggaAutoTag::VERSION
  `git tag | grep #{version}`
  already_exists = $?.exitstatus == 0
  if already_exists
    puts "-> v#{version} already exists, consider bumping"
    exit(1)
  end

  `git tag v#{version}`
  puts "=> Pushing tags"
  `git push --tags`
  puts "=> Version #{version} pushed!"
end
