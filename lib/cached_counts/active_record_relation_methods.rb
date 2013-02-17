require 'active_support'

module CachedCounts
  module ActiveRecordRelationMethods
    extend ActiveSupport::Concern

    included do
      alias_method_chain :count,  :caching
      alias_method_chain :length, :caching
      alias_method_chain :size,   :caching
    end

    def count_with_caching(*args)
      CachedCounts::Cache.new(self).count
    end

    def length_with_caching(*args)
      CachedCounts::Cache.new(self).count
    end

    def size_with_caching(*args)
      CachedCounts::Cache.new(self).count
    end

    def clear_count_cache
      CachedCounts::Cache.new(self).clear
    end
  end
end
