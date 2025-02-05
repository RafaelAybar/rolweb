class Picture < ApplicationRecord
    include DatabaseImageUploaderMounter

    mount_image_uploader

    #mount_uploader :image, ImageUploader
end
