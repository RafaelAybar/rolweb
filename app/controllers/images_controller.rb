# Uso exclusivo para sevir la fuente de imágenes

class ImagesController < ActionController::Base

  @@image_uploader ||= SilverImageUploader.new

  # Acción para servir el archivo binario como imagen descargable
  def download
    @image = @@image_uploader.get(params[:id])
    nombre = @image.nombre
    extension = File.extname(nombre).delete_prefix('.')
    send_data @image.data, filename: "#{nombre}", type: "image/#{extension}", disposition: "inline"
  end
end