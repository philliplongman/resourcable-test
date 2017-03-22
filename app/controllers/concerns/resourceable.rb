require 'accessor'

module Resourceable

  private

  def access_resources(*model_names)
    # Accepts a list of models as symbols, strings, or constants. Args may also
    # be the hash key to an array of columns to accept for strong params.
    #
    # Example:
    #   access_resources :users, :comments
    #   access_resource posts: [:title, :body, :tags]
    #
    model_names.each do |model_name|
      if model_name.is_a? Hash
        resource = (model_name.keys.first).to_s.underscore.singularize
        permitted_columns = (model_name.values.first).map(&:to_sym)
      else
        resource = model_name.to_s.downcase.singularize
        permitted_columns = nil
      end

      define_access_methods_for resource, permitted_columns
    end
  end

  alias_method :access_resource, :access_resources

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
