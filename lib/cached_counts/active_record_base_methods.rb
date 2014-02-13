require 'active_support'

module CachedCounts
  module ActiveRecordBaseMethods
    extend ActiveSupport::Concern

    included do
      after_save    :clear_count_cache
      after_destroy :clear_count_cache

      class << self
        target = case Rails::VERSION::MAJOR
        when 3
          :scoped
        when 4
          :all
        end

        delegate :clear_count_cache, :count_with_caching, :length_with_caching,
          :size_with_caching, :count_without_caching, :length_without_caching,
          :size_without_caching, :to => target
      end

      private

      def clear_count_cache
        self.class.clear_count_cache
      end
    end
  end
end