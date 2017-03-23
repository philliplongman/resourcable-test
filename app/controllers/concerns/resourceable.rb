require 'resourceable/accessor'

module Resourceable

  private

  def access_resources(*model_names, **model_hashes)
    # Accepts a list of models as symbols, strings, or constants.
    # Args may instead be a hash containing an array of columns
    # to accept for strong params.
    #
    # Example:
    #   access_resources :users, :comments
    #   access_resource posts: [:title, :body, :tags]
    #
    model_names.each do |model|
      define_access_methods_for resource_name(model), nil
    end

    model_hashes.each do |model, columns|
      define_access_methods_for resource_name(model), columns
    end
  end

  alias_method :access_resource, :access_resources

  def resource_name(name)
    name.to_s.underscore.singularize
  end

  def define_access_methods_for(resource, permitted_columns)
    # define getter for collection
    define_method resource.pluralize.to_sym do
      instance_variable_get("@#{resource.pluralize}") || begin
        # resource & permitted_columns will be hard-coded into method
        # params will get called when the the method is called
        accessor = Accessor.new(resource, permitted_columns, params)
        instance_variable_set "@#{resource.pluralize}", accessor.collection
      end
    end

    # define getter for single records
    define_method resource.to_sym do
      instance_variable_get("@#{resource}") || begin
        # resource & permitted_columns will be hard-coded into method
        # params will get called when the the method is called
        accessor = Accessor.new(resource, permitted_columns, params)
        instance_variable_set "@#{resource}", accessor.load_resource
      end
    end
  end
end
