module Resourceable

  private

  def access_resource(resource)
    resource = resource.to_s.downcase.singularize

    create_methods_for_singular_resources resource
    create_shared_methods resource
  end

  def access_resources(resource)
    resource = resource.to_s.downcase.singularize

    create_methods_for_plural_resources resource
    create_shared_methods resource
  end

  def create_methods_for_singular_resources(resource)
  end

  def create_methods_for_plural_resources(resource)
    # find existing resource by id or return nil
    define_method "existing_#{resource}" do
      id = send "#{resource}_id_from_params"
      id.present? ? resource.capitalize.constantize.find(id) : nil
    end

    # new resource
    define_method "new_#{resource}" do
      resource.capitalize.constantize.new
    end

    # find id for resource from params
    define_method "#{resource}_id_from_params" do
      return params["#{resource}_id"] if params["#{resource}_id"]
      return params[:id] if controller_name == resource.pluralize
      nil
    end
  end

  def create_shared_methods(resource)
    # getter - collection
    define_method resource.pluralize  do
      instance_variable_get("@#{resource.pluralize}") ||
        instance_variable_set(
          "@#{resource.pluralize}", resource.capitalize.constantize.all
        )
    end

    # getter - single record
    define_method resource do
      instance_variable_get("@#{resource}") ||
        instance_variable_set("@#{resource}", send("load_#{resource}"))
    end

    # find or create resource, then assign any params
    define_method "load_#{resource}" do
      record = send("existing_#{resource}") || send("new_#{resource}")
      if params[resource].present?
        record.assign_attributes send("#{resource}_params")
      end
      record
    end

    # return strong params for resource
    define_method "#{resource}_params" do
      params.require(resource).permit()
    end
  end

end
