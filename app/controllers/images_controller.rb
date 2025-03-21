class ImagesController < ModelController

  include AdminAccess
  allow_public_access_to :download
  @@cache = DiskCache.get_cache(Image) # Uso exclusivo para download

  def initialize
    super 
    @tipo = Image
  end
  
  def index
    @xs = Image.all.page(params[:page]).per(16)
  end
  
  # Solo necesario para testeos
  def create
    @image = Image.new

    # Lee el archivo y lo guarda como binario en el campo `data`
    if params[:image][:file]
      @image.data = params[:image][:file].read
      @image.nombre = params[:image][:file].original_filename
    end

    if @image.save
      redirect_to @image
    else
      redirect_to "/control" , notice: 'La jodiste.'
    end
  end

  # Acción para servir el archivo binario como imagen descargable
  def download
    @image = @@cache.fetch(params[:id])
    nombre = @image.nombre
    extension = File.extname(nombre).delete_prefix('.')
    send_data @image.data, filename: "#{nombre}", type: "image/#{extension}", disposition: "inline"
  end

  private

  def model_params
    params.require(:image)
  end
end
