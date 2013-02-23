module CachedCounts
  class Cache
    def initialize(scope)
      @scope = scope
    end

    def count(*args)
      if all_keys.include?(current_key)
        Rails.cache.fetch(current_key)
      else
        @scope.count_without_caching(*args).tap do |count|
          Rails.cache.write(current_key, count)
          Rails.cache.write(list_key, all_keys + [current_key])
        end
      end
    end

    # Clear out any count caches which have SQL that includes the scopes table
    def clear
      keys = all_keys
      invalid_keys = keys.select { |key| key.include?(@scope.table_name.downcase.singularize) }
      invalid_keys.each { |key| Rails.cache.delete(key) }

      Rails.cache.write(list_key, keys - invalid_keys)
    end

    private

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
