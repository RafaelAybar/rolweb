class Picture < ApplicationRecord
    mount_image_uploader

    has_and_belongs_to_many :etiquets
end
