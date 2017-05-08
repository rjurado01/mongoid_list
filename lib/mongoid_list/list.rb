module Mongoid
  module List
    module ClassMethods
      ##
      # Returns
      #
      def mongoid_list_fields
        instance_variable_get :@mongoid_list_fields
      end

      ##
      # Defines new list field
      #
      def list(field, opts={})
        @mongoid_list_fields[field] = opts
        field(field, type: Integer)
      end
    end

    ##
    # Returns scope for list field
    #
    def list_scope(field)
      scope_field = self.class.mongoid_list_fields[field][:scope]
      scope_field ? self.class.where(scope_field => self[scope_field]) : self.class.all
    end

    ##
    # Given current document, reorders the rest of documents in the list
    #
    # cases:
    # set 4 to 1 => [X, 1, 2, 3]
    # set 1 to 4 => [2, 3, 4, X]
    # set 3 to 2 => [1, X, 2, 4]
    # set 2 to 3 => [1, 3, X, 4]
    #
    def reorder_list(field)
      index = 1
      list_scope(field).order_by(field => 'asc').each do |document|
        next if document.id == id

        index += 1 if index == self[field] && persisted?
        document.set(field => index)
        index += 1
      end
    end

    ##
    # Adds class methods
    #
    def self.included(base)
      base.instance_variable_set :@mongoid_list_fields, {}
      base.extend(ClassMethods)

      base.send(:before_create) do
        self.class.mongoid_list_fields.keys.each do |field|
          self[field] = list_scope(field).count + 1
        end
      end

      base.send(:after_destroy) do
        self.class.mongoid_list_fields.keys.each do |field|
          reorder_list(field)
        end
      end

      base.send(:after_update) do
        self.class.mongoid_list_fields.keys.each do |field|
          reorder_list(field) if self.send("#{field}_changed?")
        end
      end
    end
  end
end
