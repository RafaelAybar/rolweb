class CuentosController < ModelController

  def initialize
    super 
    @tipo = Cuento
  end

  def model_params
    params.require(:cuento).permit(:nombre, :spoilers, :texto)
  end
end
