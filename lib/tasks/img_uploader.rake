# app/lib/tasks/img_uploader.rake

namespace :img_uploader do

  def migrate_images(source_uploader, target_uploader)
    models = [Picture, Mob, Clase, Item]

    puts "Iniciando migración de imágenes de #{source_uploader.class.name} a #{target_uploader.class.name}..."

    models.each do |model|
      puts "\nMigrando imágenes de #{model.name}..."

      model.find_each do |record|
        id = record[:image]
        next if id.blank?

        image = source_uploader.get(id)
        next unless image

        Image.transaction do
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
end
