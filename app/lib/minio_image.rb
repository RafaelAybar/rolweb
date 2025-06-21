class MinioImage
  include ImageUrlable

  attr_accessor :id, :data, :nombre

  def initialize(id:, data:, nombre:)
    @id = id
    @data = data
    @nombre = nombre
  end
end