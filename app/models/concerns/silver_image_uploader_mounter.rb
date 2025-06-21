require "active_support/concern"

module SilverImageUploaderMounter
  extend ActiveSupport::Concern

  class << self
    attr_reader :img_uploader
  end

  class_methods do
    def mount_image_uploader(att_name = :image)

      before_destroy "remove_#{att_name}!".to_sym

      define_method(:img_uploader) do
        @img_uploader_att ||= SilverImageUploader.new
      end

      define_method(att_name) do
        @image ||= img_uploader.get(read_attribute(att_name))
      end

      define_method("#{att_name}=") do |file|
        old_id = read_attribute(att_name)
        id = img_uploader.set(file, old_id)
        write_attribute(att_name, id)
      end

      define_method("remove_#{att_name}!") do
        img_uploader.remove!(read_attribute(att_name))
        write_attribute(att_name, nil)
      end

    end
  end
end