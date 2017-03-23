require 'resourceable/accessor'

module Resourceable

  private

  def access_resources(*models, **options)
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
    # Example:
    #   access_resources :users, :accounts
    #   access_resource Profile, key: :user_id, columns: [:username, :picture]
    #
    models.map! { |e| resource_name(e) }

    define_access_methods_for models.pop, options if options.present?

    models.each { |model| define_access_methods_for model }
  end

  alias_method :access_resource, :access_resources

  def resource_name(name)
    name.to_s.underscore.singularize
  end

  def define_access_methods_for(resource, options={})
    # resource & options will be hard-coded into methods
    # params will get called when the the method is called

    # define getter for collection
    define_method resource.pluralize.to_sym do
      instance_variable_get("@#{resource.pluralize}") || begin
        accessor = Accessor.new(resource, options, params)
        instance_variable_set "@#{resource.pluralize}", accessor.collection
      end
    end

    # define getter for single records
    define_method resource.to_sym do
      instance_variable_get("@#{resource}") || begin
        accessor = Accessor.new(resource, options, params)
        instance_variable_set "@#{resource}", accessor.load_resource
      end
    end
  end
end
