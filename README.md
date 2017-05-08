# MongoidList

Let you define position fields in your models to create ordered list.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mongoid_list'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid_list

## Usage

Basic list:

```ruby
class Item
  include Mongoid::Document
  include Mongoid::List

  list :position
end

item1 = Item.create
item2 = Item.create

item1.position  # => 1
item2.position  # => 2

item1.position = 2
item1.save

item1.position  # => 2
item2.position  # => 1
```

Scoped list:

```ruby
class Parent
  include Mongoid::Document
  include Mongoid::List

  list :position
end

class Child
  include Mongoid::Document
  include Mongoid::List

  belongs_to :parent

  list :position, scope: :parent_id
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mongoid_list.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

