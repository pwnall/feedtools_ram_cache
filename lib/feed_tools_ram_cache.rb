# RAM-backed cache for FeedTools.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'rubygems'
require 'feed_tools'

# :nodoc: namespace
module FeedTools


# RAM-backed cache for FeedTools.
#
# This is a drop-in replacement for FeedTools::DatabaseFeedCache that does not
# require a database.
class RamFeedCache
  # Creates a new cache item.
  def initialize(initial_values = {})
    @fields = initial_values.dup
  end
  
  # The fields in this cache item.
  attr_reader :fields
  
  # The cache state, in a format that can be serialized.
  def self.state
    @by_id.values.map { |value| value.fields }
  end
  
  # Loads previously saved state into the cache.
  def self.state=(new_state)
    clear
    new_state.each { |fields| write_item RamFeedCache.new(fields) }
  end
  
  # Removes all the cache items.
  def self.clear
    @by_id, @by_href = nil, nil
    initialize_cache    
  end
  
  # The number of entries in the cache.
  def self.length
    @by_id.length
  end
    
  # Fields required by FeedTools.
  #
  # The FeedTools documentation is outdated. The correct fields can be inferred
  # from the migration found at:
  #     http://feedtools.rubyforge.org/svn/trunk/db/migration.rb
  FIELDS =  [:id, :href, :title, :link, :feed_data, :feed_data_type,
             :http_headers, :last_retrieved, :time_to_live, :serialized]
  FIELDS.each do |field_name|
    define_method(field_name) { @fields[field_name] }
    define_method(:"#{field_name}=") { |value| @fields[field_name] = value }
  end
  
  # Cache indexes.
  @by_id, @by_href = nil, nil
  
  # Writes an item into the cache
  def self.write_item(item)
    # NOTE: FeedTools seems to rely on ActiveRecord's auto-incrementing IDs.
    item.id = @by_id.length + 1 unless item.id

    @by_id[item.id] = item
    @by_href[item.href] = item
  end    
  
  # Called by FeedTools to save the cache item.
  def save
    self.class.write_item(self)
    true
  end
  
  # Called by FeedTools.
  def new_record?
    @fields[:id].nil? ? true : false
  end
  
  # Called by FeedTools to initialize the cache.
  def self.initialize_cache
    # NOTE: the FeedTools documentation says this will be called once. In fact,
    #       the method is called over and over again.
    @by_id ||= {}
    @by_href ||= {}
  end

  # Called by FeedTools to determine if the cache is online.
  def self.connected?
    @by_id != nil
  end
  
  # FeedTools documentation doesn't specify this method, but the implementation
  # calls it.
  def self.set_up_correctly?
    connected?
  end
  
  # FeedTools documentation doesn't specify this method, but the implementation
  # calls it.
  def self.table_exists?
    true
  end
  
  # Required by FeedTools.
  def self.find_by_id(id)
    @by_id[id]
  end
  
  # Required by FeedTools.
  def self.find_by_href(url)
    @by_href[url]
  end

  # Good idea: override equality comparison so it works for equal cache entries.
  #            Must also override hash, since we're overriding ==.
  
  def ==(other)
    return false unless other.kind_of?(RamFeedCache)
    @fields == other.fields
  end
  
  def hash
    @fields.hash
  end
end  # class RamFeedCache

end  # namespace FeedTools
