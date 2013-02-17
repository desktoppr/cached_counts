require 'spec_helper'

describe CachedCounts::Cache do
  let(:scope) { Scope.new('Cat') }
  let(:cache) { described_class.new(scope) }

  before { cache.clear }

  describe '#count' do
    context 'when there is no cached count' do
      it 'returns the cached count' do
        scope.should_receive(:count_without_caching).and_return(10)
        cache.count.should == 10
      end

      it 'passes any given options to the count method' do
        scope.should_receive(:count_without_caching).with('first').and_return(5)
        cache.count('first').should == 5
      end
    end

    context 'when there is already a cached count' do
      before do
        scope.should_receive(:count_without_caching).once.and_return(8)
        cache.count
      end

      it 'returns the cached value' do
        cache.count.should == 8
      end
    end

    context 'using multiple scope objects' do
      let(:new_scope)  { Scope.new('Cat') }
      let(:same_scope) { Scope.new('Cat') }

      before { new_scope.stub(:to_sql => 'new-sql-here') }

      it 'uses a different cache for different to_sql values' do
        scope.stub(:count_without_caching => 5)
        new_scope.stub(:count_without_caching => 4)

        cache.count

        described_class.new(new_scope).count.should == 4
      end

      it 'uses the same cache for scopes with the same to_sql values' do
        scope.stub(:count_without_caching => 5)
        same_scope.should_not_receive(:count_without_caching)

        cache.count
        described_class.new(same_scope).count.should == 5
      end
    end
  end

  describe '#clear' do
    it 'clears the cached count' do
      scope.stub(:count_without_caching => 9)
      cache.count.should == 9
      cache.clear
      scope.stub(:count_without_caching => 11)

      cache.count.should == 11
    end
  end
end
