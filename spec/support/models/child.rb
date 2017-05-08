class Child
  include Mongoid::Document
  include Mongoid::List

  belongs_to :parent

  list :position, scope: :parent_id
end
