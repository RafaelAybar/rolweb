require "aws-sdk-s3"
require "securerandom"

class MinioImageUploader

  def initialize
    cfxm = Rails.configuration.x.minio
    @bucket = Aws::S3::Resource.new(
      endpoint: cfxm.endpoint,
      access_key_id: cfxm.access_key_id,
      secret_access_key: cfxm.secret_access_key,
      region: cfxm.region,
      force_path_style: true
    ).bucket(cfxm.bucket)

    raise "No se pudo conectar a Minio" unless @bucket.exists?
  end

  def get(id)
    return nil if id.nil?

    obj = @bucket.object(id)

    unless obj.exists?
      return nil
    end

    MinioImage.new(
      id: obj.key,
      data: obj.get.body.read,
      nombre: obj.metadata['nombre'] || obj.key,
      content_type: obj.content_type
    )
  end

  def add(file)
    file_data = file.read
    obj = @bucket.object(SecureRandom.uuid)
    content_type = file.respond_to?(:content_type) ? file.content_type : "application/octet-stream"
    store(
      id: obj.key,
      data: file_data,
      content_type: content_type,
      original_filename: file.original_filename
    )

    MinioImage.new(
      id: obj.key,
      data: file_data,
      nombre: file.original_filename,
      content_type: content_type
    )
  end

  def store(id:, data:, content_type:, original_filename:)
    obj = @bucket.object(id)
    obj.put(
      body: data,
      content_type: content_type,
      metadata: { 'nombre' => original_filename }
    )
  end

  def remove!(record)
    @bucket.object(record.id.to_s).delete
  end

  # Used only by backup
  def all_ids
    @bucket.objects.map &:key
  end

  def clear_all!
    @bucket.objects.each do |obj|
      obj.delete
    end
  end

end
