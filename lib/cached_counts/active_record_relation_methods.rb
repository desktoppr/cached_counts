require 'active_support'

module CachedCounts
  module ActiveRecordRelationMethods
    extend ActiveSupport::Concern

    included do
      if defined?(Rails) && Rails.configuration.respond_to?(:cache_counts_by_default) && Rails.configuration.cache_counts_by_default
        alias_method_chain :count,  :caching
        alias_method_chain :length, :caching
        alias_method_chain :size,   :caching
      else
        # Existing code calls count_without_caching, so just make it a no-op
        alias_method :count_without_caching, :count
        alias_method :length_without_caching, :length
        alias_method :size_without_caching, :size
      end
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
