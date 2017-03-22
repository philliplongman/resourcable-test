require 'resource'

module Resourceable

  private

  def access_resource(*args)
    # Accepts a list models as symbols, strings, or constants. Args may also be
    # the hash key to an array of columns to accept for strong params. Example:
    #
    #   :posts, :comments, users: [:name, :email, :password]
    #
    args.each { |arg| define_access_methods_for Resource.new(arg) }
  end

  alias_method :access_resources, :access_resource

  def define_access_methods_for(resource)
    if resource.singleton?
      define_methods_for_singleton_resource(resource)
    else
      define_methods_for_standard_resource(resource)
    end
    define_shared_methods resource
  end

  def define_methods_for_singleton_resource(resource)
  end

  def define_methods_for_standard_resource(resource)
    # find existing resource by id or return nil
    define_method "existing_#{resource}" do
      id = send "#{resource}_id_from_params"
      id.present? ? resource.constantize.find(id) : nil
    end

    # new resource
    define_method "new_#{resource}" do
      resource.constantize.new
    end

    # find id for resource from params
    define_method "#{resource}_id_from_params" do
      return params["#{resource}_id"] if params["#{resource}_id"]
      return params[:id] if controller_name == resource.pluralize
      nil
    end
  end

  def define_shared_methods(resource)
    # getter - collection
    define_method resource.pluralize  do
      instance_variable_get("@#{resource.pluralize}") ||
        instance_variable_set(
          "@#{resource.pluralize}", resource.constantize.all
        )
    end

    # getter - single record
    define_method resource.name do
      instance_variable_get("@#{resource}") ||
        instance_variable_set("@#{resource}", send("load_#{resource}"))
    end

    # find or create resource, then assign any params
    define_method "load_#{resource}" do
      record = send("existing_#{resource}") || send("new_#{resource}")
      record.assign_attributes send("#{resource}_params") if params[resource].present?
      record
    end

    # define strong params for resource that don't allow anything,
    # to be overwritten in the context of each controller
    define_method "#{resource}_params" do
      params.require(resource.name).permit(resource.permitted_columns)
    end
  end

end
