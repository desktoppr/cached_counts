module CachedCounts
  class Railtie < ::Rails::Railtie
    initializer 'cached_counts' do |app|
      ActiveSupport.on_load(:active_record) do
        ::ActiveRecord::Relation.send :include, CachedCounts::ActiveRecordRelationMethods
      end

      app.config.after_initialize { app.config.active_record.observers += [ :cached_count_observer ] }
      app.config.to_prepare { CachedCounts::CachedCountObserver.instance.reload }
    end
  end
end

