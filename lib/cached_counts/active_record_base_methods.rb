require 'active_support'

module CachedCounts
  module ActiveRecordBaseMethods
    extend ActiveSupport::Concern

    included do
      delegate :clear_count_cache, :count_with_caching, :length_with_caching,
        :size_with_caching, :count_without_caching, :length_without_caching,
        :size_without_caching, :to => :scoped
    end
  end
end
