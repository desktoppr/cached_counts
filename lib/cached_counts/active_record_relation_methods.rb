require 'active_support'

module CachedCounts
  module ActiveRecordRelationMethods
    extend ActiveSupport::Concern

    def count(*args)
      CachedCounts::Cache.new(self).count
    end

    def length(*args)
      CachedCounts::Cache.new(self).count
    end

    def size(*args)
      CachedCounts::Cache.new(self).count
    end
  end
end
