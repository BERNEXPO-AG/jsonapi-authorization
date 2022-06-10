class JSONAPI::BasicResource

  def self.resource_for_polymorphic(type, context)
    type = type.to_s.underscore
    type_with_module = type.start_with?(module_path) ? type : module_path + type
    # binding.pry
    resource_name = _resource_name_from_type(type_with_module)
    resource = resource_name.safe_constantize if resource_name
    if resource.nil?
      fail NameError, "JSONAPI: Could not find resource '#{type}'. (Class #{resource_name} not found)"
    end
    resource
  end

  def _model_class_name(key_type, context)
    type_class_name = key_type.to_s.classify
    klass = type_class_name.safe_constantize.new
    resource = self.class.resource_for(klass, context)
    resource ? resource._model.class.to_s : type_class_name
  end

end
