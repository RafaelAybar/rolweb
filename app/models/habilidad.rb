class Habilidad < ApplicationRecord
    # atributes: nombre, nivel, efecto, oculto
    has_rich_text :efecto

    has_and_belongs_to_many :clases
    has_and_belongs_to_many :items
    has_and_belongs_to_many :categs
    has_and_belongs_to_many :mobs

    scope :hide, ->(secreto=false) { where(oculto: secreto) }
end
