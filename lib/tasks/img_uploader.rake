namespace :img_uploader do
  def models
    [Picture, Mob, Clase, Item]
  end

  def migrate_images(source_uploader, target_uploader)

    puts "Iniciando migración de imágenes de #{source_uploader.class.name} a #{target_uploader.class.name}..."

    models.each do |model|
      puts "\nMigrando imágenes de #{model.name}..."

      model.find_each do |record|
        id = record[:image]
        next if id.blank?

        image = source_uploader.get(id)
        next unless image

        ActiveRecord::Base.transaction do
          file = StringIO.new(image.data)
          file.define_singleton_method(:original_filename) { image.nombre }
          file.define_singleton_method(:content_type) { "image/#{File.extname(image.nombre).delete('.')}" }

          new_id = target_uploader.add(file).id
          record.update_column(:image, new_id)
          source_uploader.remove!(image)
          puts "→ Migrada imagen para #{model.name} ##{record.id}"
        end

      end
    end

    puts "\n✅ Migración completada."
  end


  desc "Migrar imágenes de la base de datos a MinIO"
  task migrate_db_to_minio: :environment do
    migrate_images(DatabaseImageUploader.new, MinioImageUploader.new)
  end

  desc "Migrar imágenes de MinIO a la base de datos"
  task migrate_minio_to_db: :environment do
    migrate_images(MinioImageUploader.new, DatabaseImageUploader.new)
  end


  desc "Resubir todas las imágenes para convertir y reestablecer formato"
  task reupload: :environment do
    silver_uploader = SilverImageUploader.new

    puts "Iniciando resubida de imágenes usando SilverImageUploader..."
    errores = []

    models.each do |model|
      puts "\nProcesando imágenes de #{model.name}..."

      model.find_each do |record|
        image_obj = record.image
        next if image_obj.nil?
        begin
          ActiveRecord::Base.transaction do
            Tempfile.open(["reupload_tmp"], binmode: true) do |tmpfile|
              tmpfile.write(image_obj.data)
              tmpfile.rewind

              record.image = ActionDispatch::Http::UploadedFile.new(
                filename: image_obj.nombre,
                type: image_obj.content_type,
                tempfile: tmpfile
              )
              record.save!
            end
          end
        rescue => e
          errores << { model: model.name, nombre: record.nombre, error: e.message }
        end
      end
    end

    puts "\n✅ Resubida con SilverImageUploader completada."

    if errores.any?
      puts "\n⚠️ #{errores.size} imágenes no válidas encontradas:"
      errores.each do |err|
        puts "  - #{err[:model]} (#{err[:nombre]}): #{err[:error]}"
      end
    end
  end
end
