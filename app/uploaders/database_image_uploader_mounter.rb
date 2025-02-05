require "active_support/concern"

module DatabaseImageUploaderMounter
  extend ActiveSupport::Concern

  class_methods do
    def mount_image_uploader

      define_method(:init_image) do
        @image ||= (Image.find_by(id: read_attribute(:image)) || Image.new)
        Rails.logger.debug "#### init_image - DatabaseImageUploaderMounter:: image: #{@image.inspect}####"
      end

      define_method(:image) do
        Rails.logger.debug "#### image - DatabaseImageUploaderMounter ####"
        send("init_image")
        @image
      end

      define_method(:image=) do |file|
        Rails.logger.debug "#### image= - DatabaseImageUploaderMounter:: file: #{file} ####"
        send("init_image")
        if file
          @image.data = file.read
          @image.nombre = file.original_filename
          send("store_image!")
        end
      end

      define_method(:image_url) do
        Rails.logger.debug "#### image_url - DatabaseImageUploaderMounter ####"
        raise "image_url"
        @image.url
      end

      define_method(:image_cache) do
        raise "No existe archivo de cache de la imagen"
      end

      define_method(:image_cache=) do |cache|
        raise "No se puede asignar un archivo de cache de la imagen"
      end

      define_method(:remote_image_url) do
        raise "No exsite URL remota de la imagen"
      end

      define_method(:remote_image_url=) do |url|
        raise "No se puede obtener archivo por URL remota"
      end

      define_method(:remove_image) do
        raise "remove_image"
        instance_variable_get("@remove_image")
      end

      define_method(:remove_image=) do |value|
        raise "remove_image="
        instance_variable_set("@remove_image", value)
      end

      define_method(:remove_image?) do
        raise "remove_image?"
        send("remove_image") == true
      end

      define_method(:store_image!) do
        Rails.logger.debug "#### store_image! - DatabaseImageUploaderMounter ####"
        if false #send("remove_image?")
          @image.destroy
          write_attribute(:image, nil)
        else
          @image.save!
          write_attribute(:image, @image.id.to_s)
          Rails.logger.debug "store_image! - DatabaseImageUploaderMounter:: stored: #{@image.id} || #{@image.inspect}"
        end
      end

      define_method(:remove_image!) do
        Rails.logger.debug "#### remove_image! - DatabaseImageUploaderMounter ####"
        raise "remove_image!"
        send("remove_image=true")
        send("store_image!")
      end

      define_method(:image_integrity_error) do
        # Implementar validaciones si es necesario
        raise "image_integrity_error no implementado"
      end

      define_method(:image_processing_error) do
        # Implementar manejo de errores de procesamiento si es necesario
        raise "image_processing_error no implementado"
      end

      define_method(:image_download_error) do
        # Implementar manejo de errores de descargas remotas si es necesario
        raise "image_download_error no implementado"
      end

      define_method(:image_identifier) do
        raise "image_identifier"
      end
    end
  end
end
