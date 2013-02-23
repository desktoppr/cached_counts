module CachedCounts
  class Cache
    def initialize(scope)
      @scope = scope
    end

    def count(*args)
      cached_count || uncached_count(*args)
    end

    # Clear out any count caches which have SQL that includes the scopes table
    def clear
      invalid_keys = all_keys.select { |key| key.include?(@scope.table_name.downcase.singularize) }
      invalid_keys.each { |key| Rails.cache.delete(key) }

      Rails.cache.write(list_key, all_keys - invalid_keys)
    end

    private

    def cached_count
      Rails.cache.fetch(current_key)
    end

    def uncached_count(*args)
      @scope.count_without_caching(*args).tap do |count|
        Rails.cache.write(current_key, count)
        Rails.cache.write(list_key, all_keys + [current_key])
      end
    end

    def all_keys
      Rails.cache.fetch(list_key) || []
    end

    def list_key
      "cached_counts::keys"
    end

    def current_key
      "cached_counts::#{@scope.to_sql.downcase}"
    end
  end
end
