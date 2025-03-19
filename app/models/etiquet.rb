class Etiquet < ApplicationRecord
    # atributes: nombre, color
  has_and_belongs_to_many :pictures
end
