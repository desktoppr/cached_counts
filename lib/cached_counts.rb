begin
  require 'rails'
  require 'cached_counts/railtie'
rescue LoadError
  #do nothing
end

require 'cached_counts/active_record_relation_methods'
require 'cached_counts/cache'
require 'cached_counts/cached_count_observer'
require 'cached_counts/version'

module CachedCounts
end
