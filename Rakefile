# Rakefile that uses echoe to manage feed_tools_ram_cache's gemspec. 
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'rubygems'
require 'echoe'

Echoe.new('feedtools_ram_cache') do |p|
  p.project = 'zerglings'  # RubyForge project.
  
  p.author = 'Victor Costan'
  p.email = 'victor@zergling.net'
  p.summary = "RAM-based cache for FeedTools."
  p.url = 'http://github.com/costan/feed_tools_ram_cache'
  p.dependencies = ["feedtools >=0.2.29"]
  p.development_dependencies = ["echoe >=3.1.1", "flexmock >=0.8.6"]
  
  p.need_tar_gz = true
  p.need_zip = true
  p.rdoc_pattern = /^(lib|bin|tasks|ext)|^BUILD|^README|^CHANGELOG|^TODO|^LICENSE|^COPYING$/  
end

if $0 == __FILE__
  Rake.application = Rake::Application.new
  Rake.application.run
end
