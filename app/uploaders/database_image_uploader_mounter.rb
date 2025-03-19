require "active_support/concern"

module DatabaseImageUploaderMounter
  extend ActiveSupport::Concern

  class << self
    attr_reader :dbiu
  end
  @dbiu = DatabaseImageUploader.new

  class_methods do
    def mount_image_uploader(att_name = :image)

      before_destroy "remove_#{att_name}!".to_sym

      define_method(:dbiu) do
        DatabaseImageUploaderMounter.dbiu
      end

      define_method(att_name) do
        Rails.logger.debug "Method: #{att_name}"
        @image ||= dbiu.get(read_attribute(att_name))
      end

      define_method("#{att_name}=") do |file|
        Rails.logger.debug "Method: #{att_name}="
        old_id = read_attribute(att_name)
        id = dbiu.set(file, old_id)
        write_attribute(att_name, id)
      end

      define_method("remove_#{att_name}!") do
        Rails.logger.debug "Method: remove!"
        dbiu.remove!(read_attribute(att_name))
        write_attribute(att_name, nil)
      end

    end
  end
end
