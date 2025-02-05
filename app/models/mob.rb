class Mob < ApplicationRecord
    has_and_belongs_to_many :items
    has_and_belongs_to_many :habilidads
    has_and_belongs_to_many :habilidadsOfMob, class_name: "Habilidad", join_table: 'mobsHasHabil'
    
    include DatabaseImageUploaderMounter
    mount_image_uploader
end
