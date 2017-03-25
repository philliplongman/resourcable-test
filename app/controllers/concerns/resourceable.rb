# frozen_string_literal: true

require "resourceable/accessor"

# Module to DRY controllers by encapsulating finding/initializing ActiveRecord
# resources and assigning params data in a PORO. ::access_resource is called at
# the top of the controller for every resource you want to access, and two
# memo-ized getter methods are metaprogramatically defined for each. When
# called, they generate an Accessor object that returns the correct object,
# loaded with the params, but not saved.
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

  alias access_resources access_resource

  def define_access_methods_for(resource, options = {})
    resource = resource.to_s.underscore.singularize

    define_memoized_getter_for_collection resource, options
    define_memoized_getter_for_single_record resource, options
  end

  def define_memoized_getter_for_collection(resource, options = {})
    # resource & options will be hard-coded into the method
    # params will get called when the methods is called
    define_method resource.pluralize.to_sym do
      instance_variable_get("@#{resource.pluralize}") || begin
        accessor = Accessor.new(resource, options, params)
        instance_variable_set "@#{resource.pluralize}", accessor.collection
      end
    end
  end

  def define_memoized_getter_for_single_record(resource, options = {})
    # resource & options will be hard-coded into the method
    # params will get called when the methods is called
    define_method resource.to_sym do
      instance_variable_get("@#{resource}") || begin
        accessor = Accessor.new(resource, options, params)
        instance_variable_set "@#{resource}", accessor.load_resource
      end
    end
  end

end
