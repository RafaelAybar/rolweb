class Estadoalterado < ApplicationRecord
  # atributes: nombre, descripcion
  has_rich_text :descripcion
end
