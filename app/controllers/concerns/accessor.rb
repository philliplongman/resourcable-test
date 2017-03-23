module Resourceable
  class Accessor
    attr_reader :resource, :permitted_columns

    def initialize(resource, permitted_columns, params)
      @resource = resource.to_s.underscore.singularize
      @klass = resource.camelize.constantize
      @permitted_columns = permitted_columns
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

    attr_reader :klass, :params

    def identifier
      if singleton?
        {}
      else
        { id: resource_id_from_params }
      end
    end

    def singleton?
      false
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
      klass.column_names.select { |column| column.end_with? "_id" }
    end

    def resource_params
      params.require(resource).permit(permitted_columns)
    end

  end
end
