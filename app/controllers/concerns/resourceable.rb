require 'resourceable/accessor'

module Resourceable

  private

  def access_resource(*models, **options)
    # Accepts a list of ActiveRecord models as symbols, strings, or constants.
    # Can also accept a single model and the following keyword options:
    #
    # key:
    #   The db column to use for finding the resource in this context.
    # columns:
    #   The columns you want to permit access to in this context.
    #   When the resource is loaded, data for these columns will be
    #   automatically assigned using strong params
    #
    # Examples:
    #   access_resources :users, :accounts
    #   access_resource Profile, key: :user_id, columns: [:username, :picture]
    #
    define_access_methods_for models.pop, options if options.present?

    models.each { |model| define_access_methods_for model }
  end

  alias_method :access_resources, :access_resource

  def define_access_methods_for(resource, options={})
    resource = resource.to_s.underscore.singularize
    # resource & options will be hard-coded into the methods
    # params will get called when the methods are called

    # define memoized getter method for collection
    define_method resource.pluralize.to_sym do
      instance_variable_get("@#{resource.pluralize}") || begin
        accessor = Accessor.new(resource, options, params)
        instance_variable_set "@#{resource.pluralize}", accessor.collection
      end
    end

    # define memoized getter method for single records
    define_method resource.to_sym do
      instance_variable_get("@#{resource}") || begin
        accessor = Accessor.new(resource, options, params)
        instance_variable_set "@#{resource}", accessor.load_resource
      end
    end
  end
end
