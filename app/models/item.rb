class Item < ApplicationRecord
    # atributes: nombre, coste, peso, efecto, image
    has_rich_text :efecto

    mount_image_uploader

    remove_attribute_if_checked :image

    has_and_belongs_to_many :clases
    has_and_belongs_to_many :habilidads
    has_and_belongs_to_many :mobs
    has_and_belongs_to_many :categs
end
