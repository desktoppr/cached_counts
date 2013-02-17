require 'active_record'

module CachedCounts
  class CachedCountObserver < ActiveRecord::Observer
    observe :'ActiveRecord::Base'

    def reload
      observed_classes.each do |klass|
        klass.name.constantize.add_observer(self)
      end
    end

    def after_save(record)
      CachedCounts::Cache.new(self.class).clear
    end

    def after_destroy(record)
      CachedCounts::Cache.new(self.class).clear
    end
  end
end
