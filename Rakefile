desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r finishing_moves.rb"
end
task :c => :console

desc "Connect to RubyGems.org account"
task :authgem do
  sh "curl -u forgecrafted https://rubygems.org/api/v1/api_key.yaml > ~/.gem/credentials; chmod 0600 ~/.gem/credentials"
end

desc "Build the gem according to gemspec"
task :buildgem do
  sh "gem build finishing_moves.gemspec"
end
