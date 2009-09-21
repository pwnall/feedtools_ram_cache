# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'feed_tools_ram_cache'
require 'test/unit'

require 'benchmark'
require 'open-uri'


class IntegrationTest < Test::Unit::TestCase
  def setup
    FeedTools.configurations[:feed_cache] = FeedTools::RamFeedCache
    FeedTools::RamFeedCache.clear
  end
  
  def test_with_atom
    uri = 'http://feeds2.feedburner.com/VictorCostan'
    _test_cache uri
  end
  
  def test_with_rss
    uri = 'http://events.mit.edu/rss/'
    _test_cache uri
  end
  
  def _test_cache(uri)
    feed, cached_feed = nil, nil
    time = Benchmark.realtime do
      feed = FeedTools::Feed.open(uri)
      # NOTE: would like to include item instantiation, but it turns out parsing
      #       takes forever and dominates the running time
      # feed.items.each { |item| item.description } 
    end
    
    # Make sure the cache's state is YAML-serializable
    yaml_state = FeedTools::RamFeedCache.state.to_yaml
    FeedTools::RamFeedCache.state = YAML.load yaml_state
    
    cached_time = Benchmark.realtime do
      cached_feed = FeedTools::Feed.open uri
      # NOTE: would like to include item instantiation, but it turns out parsing
      #       takes forever and dominates the running time
      # cached_feed.items.each { |item| item.description } 
    end

    assert !cached_feed.live?, 'cached_feed is live?'
    assert_operator cached_time, :< , time / 3,
                    'Cached retrieval should be faster'    
    
    assert_equal feed.items.length, cached_feed.items.length,
                 'Incorrect cached data (item count)'
    feed.items.each_index do |i|
      [:guid, :published, :link, :summary, :description].each do |field|
        assert_equal cached_feed.items[i].send(field),
                     feed.items[i].send(field),
                     "Incorrect cached data at index #{i} field #{field}: " +
                     feed.items[i].inspect + ' vs ' + 
                     cached_feed.items[i].inspect
      end
    end
  end
end
