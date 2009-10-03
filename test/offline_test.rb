# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'feed_tools_ram_cache'
require 'test/unit'


class OfflineTest < Test::Unit::TestCase
  def setup
    FeedTools.configurations[:feed_cache] = FeedTools::RamFeedCache
    fixtures_path = File.join File.dirname(__FILE__), 'fixtures' 
    FeedTools::RamFeedCache.state =
        YAML.load File.read(File.join(fixtures_path, 'expired_cache.yml'))    
    @url = "http://events.mit.edu/rss/"
  end
  
  def test_offline_and_online
    FeedTools::RamFeedCache.offline_mode = true
    feed = FeedTools::Feed.open @url
    assert !feed.live?, "Offline mode resulted in live feed"
    
    FeedTools::RamFeedCache.offline_mode = false
    feed = FeedTools::Feed.open @url
    assert feed.live?, "Online mode read expired feed"
  end
end
