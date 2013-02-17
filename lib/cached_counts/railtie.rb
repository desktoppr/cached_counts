module CachedCounts
  class Railtie < ::Rails::Railtie
    initializer 'cached_counts' do |app|
      ActiveSupport.on_load(:active_record) do
        ::ActiveRecord::Relation.send :include, CachedCounts::ActiveRecordRelationMethods
        ::ActiveRecord::Base.send :include, CachedCounts::ActiveRecordBaseMethods
      end
    end
  end
end

