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

    def clear
      all_keys.each { |key| Rails.cache.delete(key) }
      Rails.cache.delete(list_key)
    end

    private

    def all_keys
      Rails.cache.fetch(list_key) || []
    end

    def list_key
      "count:#{@scope.model_name.underscore}::keys"
    end

    def current_key
      "count:#{@scope.model_name.underscore}::cached_count::#{@scope.to_sql}"
    end
  end
end
