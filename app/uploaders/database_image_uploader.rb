require_relative '../lib/hybrid_cache'

class DatabaseImageUploader
  def initialize
    @cache = DiskCache.get_cache(Image)
  end
  
  def get(id)
    @cache.fetch(id)
  end

  def set(file, old_id)
    raise "Nil file when trying to set image" if file.nil?
    Rails.logger.debug "DatabaseImageUploader#set: #{file.original_filename}, #{old_id}"
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
