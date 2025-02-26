class Picture < ApplicationRecord
    include DatabaseImageUploaderMounter
    mount_image_uploader

    has_and_belongs_to_many :etiquets
end
