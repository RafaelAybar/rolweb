class Picture < ApplicationRecord
    include DatabaseImageUploaderMounter
    mount_image_uploader
end
