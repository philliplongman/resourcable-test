module Resourceable
  class Accessor
    attr_reader :resource, :permitted_columns

    def initialize(resource, permitted_columns, params)
      @resource = resource.to_s.underscore.singularize
      @klass = resource.camelize.constantize
      @permitted_columns = permitted_columns.map(&:to_sym)
      @params = params
    end

    def collection
      klass.all
    end

    def load_resource
      # could probably replace this with find or init by #identifier_hash
      record = existing_resource || new_resource
      record.assign_attributes resource_params if params[resource].present?
      record
    end

    def resource_params
      params.require(resource).permit(permitted_columns)
    end

    private

    attr_reader :klass, :params

    def existing_resource
      id = resource_id_from_params
      id.present? ? klass.find(id) : nil
    end

    def new_resource
      klass.new
    end

    def resource_id_from_params
      params["#{resource}_id"] || (params[:id] if eponymous_controller?) || nil
    end

    def eponymous_controller?
      params[:controller] == resource.pluralize
    end

  end
end
