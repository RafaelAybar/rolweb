class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  include SilverImageUploaderMounter
  include RemoveAttributeIfChecked
end
