# frozen_string_literal: true

module Resourceable
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
      record = klass.find_or_initialize_by(identifier)
      if params[resource].present?
        record.assign_attributes association_params
        record.assign_attributes resource_params
      end
      record
    end

    private

    attr_reader :key, :klass, :params

    def identifier
      key ? { key => params[key] } : { id: resource_id_from_params }
    end

    def resource_id_from_params
      params["#{resource}_id"] || (params[:id] if eponymous_controller?) || nil
    end

    def eponymous_controller?
      params[:controller] == resource.pluralize
    end

    def association_params
      params.require(resource).permit(associations)
    end

    def associations
      (klass.column_names - [key.to_s]).select do |column|
        column.end_with? "_id"
      end
    end

    def resource_params
      params.require(resource).permit(permitted_columns)
    end

  end
end
