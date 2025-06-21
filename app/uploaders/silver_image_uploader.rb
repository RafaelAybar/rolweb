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
end