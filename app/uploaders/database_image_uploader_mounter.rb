class Image < ApplicationRecord
  # atributes: nombre, data
  
  include Rails.application.routes.url_helpers
  def url
    self.id ? download_image_path(self.id) : nil
  end
end

class ImagesController < ActionController::Base
  # Acción para servir el archivo binario como imagen descargable
  def download
    @image = DiskCache.get_cache(Image).fetch(params[:id])
    nombre = @image.nombre
    extension = File.extname(nombre).delete_prefix('.')
    send_data @image.data, filename: "#{nombre}", type: "image/#{extension}", disposition: "inline"
  end
  
end

class DatabaseImageUploader
  def initialize
    @cache = DiskCache.get_cache(Image)
  end
  
  # @return nil if not found
  def get(id)
    @cache.fetch(id)
  end

  def set(file, old_id)
    raise "Nil file when trying to set image" if file.nil?
    Image.transaction do
      remove!(old_id) if Image.exists? old_id
      img = Image.create!(
        data: file.read,
        nombre: file.original_filename)
      @cache.store(img)
      img.id
    end
  end

  def remove!(id)
    record = @cache.fetch(id)
    if record
      @cache.remove(id)
      record.destroy
    else
      Rails.logger.warn "DatabaseImageUploader#remove: Se ha intentado eliminar la imagen no existente, id: #{id}"
    end
  end
end

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
        @image ||= dbiu.get(read_attribute(att_name))
      end

      define_method("#{att_name}=") do |file|
        old_id = read_attribute(att_name)
        id = dbiu.set(file, old_id)
        write_attribute(att_name, id)
      end

      define_method("remove_#{att_name}!") do
        dbiu.remove!(read_attribute(att_name))
        write_attribute(att_name, nil)
      end

    end
  end
end