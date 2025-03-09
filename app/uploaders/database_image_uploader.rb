class DatabaseImageUploader
  # Nota importante: en image se guarda el id de
  # la imagen en la base de datos como un string.
  # Esto es porque otros uploaders usan un string
  # para ello. Pero como el id es un entero en la
  # base de datos, pues a hacer castings.
  # 
  # Todo esto es muy bonito para tener en cuenta
  # pero parece que al final a ruby on rails se
  # la pela y se come el string igual con patatas.
  
  def get(id)
    Image.find_by(id: id)
  end

  def set(file, old_id)
    raise "Nil file when trying to set image" if file.nil?
    Rails.logger.debug "DatabaseImageUploader#set: #{file.original_filename}, #{old_id}"
    Image.transaction do
      remove!(old_id) if Image.exists? old_id
      img = Image.create!(
        data: file.read,
        nombre: file.original_filename)
      img.id
    end
  end

  def remove!(id)
    record = get(id)
    if record
      record.destroy
    else
      Rails.logger.warn "DatabaseImageUploader#remove: Se ha intentado eliminar la imagen no existente, id: #{id}"
    end
  end
end
