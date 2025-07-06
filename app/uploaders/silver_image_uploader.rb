class SilverImageUploader
  def initialize
    @cache = ImageUploaderConfig.cache_type.get_cache(Image)
  end

  # @return nil if not found
  def get(id)
    return nil if id.blank?
    
    if (c_img = @cache.fetch(id))
      return c_img 
    end

    if u_img = ImageUploaderConfig.uploader.get(id)
      @cache.store(u_img)
      u_img
    else
      Rails.logger.warn "DatabaseImageUploader#get: Imagen no encontrada, id: #{id}"
      OpenStruct.new(id: id, not_found?: true)
    end
  end

  def set(file, old_id)
    raise "DatabaseImageUploader.set: Nil file when trying to set image" if file.nil?
    
    file = self.class.to_webp(file)
    Image.transaction do
      remove!(old_id)
      img = ImageUploaderConfig.uploader.add(file)
      @cache.store(img)
      img.id
    end
  end
  
  def remove!(id)
    record = @cache.fetch(id)
    if record
      @cache.remove(id)
      ImageUploaderConfig.uploader.remove!(record)
    else
      Rails.logger.warn "DatabaseImageUploader#remove: Se ha intentado eliminar la imagen no existente, id: #{id}"
    end
  end

  class BadImageFileError < StandardError; end

  private

  require "mini_magick"
  def self.to_webp(file)
    begin
      image = MiniMagick::Image.new(file.tempfile.path)
      image.validate!
    rescue
      raise BadImageFileError, "El archivo no es una imagen válida"
    end
    
    return file if image.mime_type == "image/webp"

    image.format("webp") do |f|
      f.quality Rails.application.config.webp_quality
    end

    tmpfile = Tempfile.new(["converted-", ".webp"], binmode: true)
    image.write(tmpfile.path)

    ActionDispatch::Http::UploadedFile.new(
      filename: "#{File.basename(file.original_filename, '.*')}.webp",
      type: "image/webp",
      tempfile: tmpfile
    )
  end
end