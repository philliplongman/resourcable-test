# frozen_string_literal: true

module Resourceable
  # PORO to encapsulate the business logic of finding/initializing ActiveRecord
  # objects and loading data from params. Returned records are not saved.
  class Accessor
    attr_reader :resource, :permitted_columns

    def initialize(resource, options, params)
      @resource = resource.to_s.underscore.singularize
      @klass = resource.camelize.constantize
      @key = options[:key]
      @permitted_columns = options[:columns]
      @params = params
    end

    def collection
      klass.all
    end

    def load_resource
      resource = existing_resource || new_resource
      resource.tap { |r| r.assign_attributes updated_attributes }
    end

    private

    attr_reader :key, :klass, :params

    def existing_resource
      klass.find_by identifier unless new_or_create_action?
    end

    def new_resource
      klass.new identifier
    end

    def new_or_create_action?
      %w(new create).include? params[:action]
    end

    def identifier
      key ? { key => params[key] } : { id: resource_id_from_params }
    end

    def resource_id_from_params
      params["#{resource}_id"] || (params[:id] if eponymous_controller?) || nil
    end

    def eponymous_controller?
      params[:controller] == resource.pluralize
    end

    def updated_attributes
      params[resource].present? ? resource_params : {}
    end

    def resource_params
      params.require(resource).permit(associations, permitted_columns)
    end

    def associations
      (klass.column_names - [key.to_s]).select { |col| col.end_with? "_id" }
    end

  end
end
