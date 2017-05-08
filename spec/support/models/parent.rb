class Parent
  include Mongoid::Document
  include Mongoid::List

  list :position
end
