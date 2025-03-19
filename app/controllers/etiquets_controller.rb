class EtiquetsController < ModelController
  def initialize
    super 
    @tipo = Etiquet
  end

  def model_params
    params.require(:etiquet).permit(:nombre, :color, picture_ids: [])
  end
end
