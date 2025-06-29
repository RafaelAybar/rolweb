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
      nombre: obj.metadata['nombre'] || obj.key
    )
  end

  def add(file)
    file_data = file.read
    obj = @bucket.object(SecureRandom.uuid)
    obj.put(
      body: file_data,
      content_type: file.respond_to?(:content_type) ? file.content_type : "application/octet-stream",
      metadata: { 'nombre' => file.original_filename }
    )
    MinioImage.new(
      id: obj.key,
      data: file_data,
      nombre: file.original_filename
    )
  end

  def remove!(record)
    @bucket.object(record.id.to_s).delete
  end

  # Used only by backup
  def all_ids
    @bucket.objects.map &:key
  end

end
