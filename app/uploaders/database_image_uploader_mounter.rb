require "active_support/concern"

module DatabaseImageUploaderMounter
  extend ActiveSupport::Concern

  class_methods do
    def mount_image_uploader

      before_destroy :remove_image!

      define_method(:init_image) do
        @image ||= (Image.find_by(id: read_attribute(:image)) || Image.new)
      end

      define_method(:image) do
        init_image
        @image
      end

      define_method(:image=) do |file|
        init_image
        if file
          @image.data = file.read
          @image.nombre = file.original_filename
          store_image!
        else
          raise "Nil file when trying to set image"
        end
      end

      define_method(:store_image!) do
        @image.save!
        write_attribute(:image, @image.id.to_s)
      end

      define_method(:remove_image!) do
        init_image
        @image.destroy
        write_attribute(:image, nil)
      end

    end
  end
end
