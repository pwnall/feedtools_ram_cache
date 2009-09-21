# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{feedtools_ram_cache}
  s.version = "1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Victor Costan"]
  s.date = %q{2009-09-20}
  s.description = %q{RAM-based cache for FeedTools.}
  s.email = %q{victor@zergling.net}
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README.textile", "lib/feed_tools_ram_cache.rb"]
  s.files = ["CHANGELOG", "LICENSE", "Manifest", "README.textile", "Rakefile", "lib/feed_tools_ram_cache.rb", "test/cache_test.rb", "test/fixtures/unit.yml", "test/integration_test.rb", "feedtools_ram_cache.gemspec"]
  s.homepage = %q{http://github.com/costan/feed_tools_ram_cache}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Feedtools_ram_cache", "--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{zerglings}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{RAM-based cache for FeedTools.}
  s.test_files = ["test/cache_test.rb", "test/integration_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<feed_tools>, [">= 0.2.29"])
      s.add_development_dependency(%q<echoe>, [">= 3.1.1"])
      s.add_development_dependency(%q<flexmock>, [">= 0.8.6"])
    else
      s.add_dependency(%q<feed_tools>, [">= 0.2.29"])
      s.add_dependency(%q<echoe>, [">= 3.1.1"])
      s.add_dependency(%q<flexmock>, [">= 0.8.6"])
    end
  else
    s.add_dependency(%q<feed_tools>, [">= 0.2.29"])
    s.add_dependency(%q<echoe>, [">= 3.1.1"])
    s.add_dependency(%q<flexmock>, [">= 0.8.6"])
  end
end
