module Resourceable
  class Resource
    attr_reader :name, :permitted_columns

    def initialize(model)
      if model.is_a? Hash
        @name = model.keys.first.to_s.downcase.singularize
        @permitted_columns = model.values.first
      else
        @name = model.to_s.downcase.singularize
        @permitted_columns = nil
      end
    end

    def to_s
      name
    end

    def to_sym
      name.to_sym
    end

    def pluralize
      name.pluralize
    end

    def constantize
      name.capitalize.constantize
    end

    def singleton?
      false
    end

  end
end
