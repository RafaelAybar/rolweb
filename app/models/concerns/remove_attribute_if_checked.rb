module RemoveAttributeIfChecked
  extend ActiveSupport::Concern

  class_methods do
    def remove_attribute_if_checked(attribute)
      attr_accessor "remove_#{attribute}".to_sym

      # Requiere que remove_#{attribute} esté definido en el modelo
      before_save "remove_#{attribute}!".to_sym, if: -> { send("remove_#{attribute}") == '1' }
    end
  end
end
