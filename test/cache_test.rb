# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'feed_tools_ram_cache'
require 'test/unit'


class CacheTest < Test::Unit::TestCase
  Cache = FeedTools::RamFeedCache
  
  def setup
    Cache.state = []
    Cache.new(:href => "google").save
    Cache.new(:href => "yahoo").save
    Cache.new(:href => "bing", :id => 100).save
    Cache.new(:href => "ask").save    
    
    @golden_fields = Hash[*Cache::FIELDS.map { |f| [f, _value(f)] }.flatten]
    fixtures_path = File.join File.dirname(__FILE__), 'fixtures' 
    @golden_state = YAML.load File.read(File.join(fixtures_path, 'unit.yml'))
  end
  
  # The golden value for a field. This is the field's value in golden_state.
  def _value(field)
    "Value: #{field} - #{field.to_s.reverse}"
  end
  
  def _check_field_fetch(item)
    Cache::FIELDS.each do |field|
      assert_equal _value(field), item.send(field),
                   "Field fetch check failed for field #{field}"
    end
  end
  
  def _check_state(item)
    assert_equal @golden_fields, item.fields, 'Item state check failed'
  end
  
  def test_item_fields
    item = Cache.new
    Cache::FIELDS.each { |field| item.send :"#{field}=", _value(field) }
    _check_field_fetch item
    _check_state item    
  end
  
  def test_item_state_load
    item = Cache.new @golden_fields
    _check_field_fetch item
    _check_state item
  end
  
  def test_length
    assert_equal 4, Cache.length, 'Incorrect number of cache entries'
  end
   
  
  def test_find_by_id
    assert_equal nil, Cache.find_by_id(0), 'ID 0 should not exist'
    assert_equal 'google', Cache.find_by_id(1).href
    assert_equal 'yahoo', Cache.find_by_id(2).href
    assert_equal 'bing', Cache.find_by_id(100).href
    assert_equal 'ask', Cache.find_by_id(4).href
  end
  
  def test_find_by_href
    assert_equal nil, Cache.find_by_href('inktomi'), 'Inktomi should not exist'
    assert_equal 1, Cache.find_by_href('google').id
    assert_equal 2, Cache.find_by_href('yahoo').id 
    assert_equal 100, Cache.find_by_href('bing').id  
    assert_equal 4, Cache.find_by_href('ask').id
  end
  
  def test_equality
    assert_equal Cache.find_by_id(1), Cache.find_by_href('google')             
    assert_not_equal Cache.find_by_id(2), Cache.find_by_href('google')
    assert_not_equal Cache.find_by_id(2), nil
    assert_not_equal nil, Cache.find_by_href('google')
  end
  
  def test_hash
    assert_equal Cache.new(Cache.find_by_id(1).fields).hash,
                 Cache.find_by_href('google').hash
    assert_not_equal Cache.find_by_id(2).hash, Cache.find_by_href('google').hash
  end
  
  def test_state_storing
    assert_equal @golden_state, Cache.state
  end
  
  def test_clear
    Cache.clear
    assert_equal 0, Cache.length, 'Cache not cleared -- found entries'
    assert_equal nil, Cache.find_by_id(1), 'Cache not cleared - found ID 1'
    assert_equal nil, Cache.find_by_href('google'),
                 'Cache not cleared - found HREF google'
  end
  
  def test_state_loading
    Cache.state = [{:id => 1}]
    
    assert_equal 1, Cache.length, 'Cache state not reset, too many entries'
    assert_equal nil, Cache.find_by_id(2), 'Cache state not reset - found ID 2'
    assert_equal nil, Cache.find_by_href('google'),
                 'Cache state not reset - found google'
  end
  
  def test_state_reloading
    Cache.clear
    Cache.state = @golden_state
    
    test_length
    test_find_by_id
    test_find_by_href
    test_equality
    test_hash
  end
end
