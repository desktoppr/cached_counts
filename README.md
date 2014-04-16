# Cached Counts

Performing `COUNT(*)` operations in relational databases can get slow for large sets of data. There are already existing ways to deal with improving counting performance and techniques to avoid doing it altogether.

This gem adds caching support to the `ActiveRecord::Relation` class to allow repeated count calls to be cached. Counts are cached based on the query that is to be run and cleared when records are saved or destroyed.

Cached counts works well with tables that are large and have many more selects than inserts. You will see *some* benefits even in tables that have regular inserts, but the gains will not be as great.


## Installation

Add it to your gemfile in your Rails 3.2+ project

    gem 'cached_counts'

Cached counts uses your Rails.cache setup, for a good memcached store, [look at dalli](https://github.com/mperham/dalli)

## Usage

You can use the size, length or count method on any active record model.

```ruby
  User.count # => # Cached count value
  User.size # => # Cached count value
  User.length # => # Cached count value
```

You can use scopes as well

```ruby
  User.where(:admin => true).count # Cached count value for this specific query
```

You can clear the cache at any time for a model:

```ruby
  User.clear_count_cache
```

You can also use the non cached count on the class or scopes.

```ruby
  User.count_without_caching # => Runs a database lookup
  User.where(:admin => true).count_without_caching # => Runs a database lookup
```

## Usage with Rails

If you're using rails you can optionally disable the ovveriding of the `count` `size` and `lenght` methods by setting the `count_with_caching` configuration value.
You can do so in your application config like so:

```ruby
# config/application.rb

module MyApp
  class Application < Rails::Application
    #...
    config.cache_counts_by_default = false
    #...
  end
end
```

Disabling the cache by default allows you to use `MyModel.count_with_caching` to return the cached count value.

## Clearing the cache

The counts cache is cleared for a model after save and after destroy.
If you are updating the database manually without these methods then you will need to clear the cache yourself.

```ruby
User.update_all(:name => 'joe')
User.clear_count_cache
```

## Example

```
1.9.3p194 :020 > User.count
   (0.2ms)  SELECT COUNT(*) FROM "users"
 => 130 
1.9.3p194 :021 > User.count
 => 130
1.9.3p194 :022 > User.last.destroy
 # ...
 => #<User id: 131 ...>
1.9.3p194 :023 > User.count
   (0.4ms)  SELECT COUNT(*) FROM "users"
 => 129
1.9.3p194 :024 > User.count
 => 129
1.9.3p194 :036 > User.where(:admin => true).count
   (0.5ms)  SELECT COUNT(*) FROM "users" WHERE "users"."admin" = 't'
 => 72
1.9.3p194 :037 > User.where(:admin => true).count
 => 72
1.9.3p194 :038 >
```

## TODO
 - Better testing
