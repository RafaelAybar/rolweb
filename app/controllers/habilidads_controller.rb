class HabilidadsController < ModelController

  def initialize
    super 
    @tipo = Habilidad
  end

  # Realmente estos accesos no están protegidos, cualquiera con la url se puede meter, pero sólo puedes conseguir la url autentifícándote en admin_controller
  # Sobrescribe.
  def index
    if params[:mode] == "sueltas"
      @xs = Habilidad.hide.left_outer_joins(:items, :clases).where(items: { id: nil }, clases: { id: nil })
    else
      if params[:mode] == "hidden"
        @secreto = true
      end
      super
    end
  end

  def new
    @x = @tipo.new
    if params.key?(:newdndspell)
      @x.nombre = params[:name]
      @x.nivel = params[:level]
      @x.efecto = params[:desc]
      @dndClases = params[:clases]
    end
  end

  # Vista especial para clasificar habilidades sin tipo
  def clasificar
    @habilidad = Habilidad.where(tipo: nil).first
    @pendientes = Habilidad.where(tipo: nil).count

    if @habilidad.nil?
      redirect_to habilidads_path, notice: "¡Ya no quedan habilidades por clasificar!"
    end
  end

  def update
    @x = @tipo.find(params[:id])
    
    if @x.update(model_params)
      if params[:from_clasificar]
        redirect_to clasificar_habilidad_path, notice: "Guardada correctamente, continuamos."
      else
        redirect_to @x
      end
    else
      render :edit
    end
  end

  def model_params
    params.require(:habilidad).permit(:nombre, :nivel, :efecto, :oculto, :tipo, clase_ids: [], item_ids: [], categ_ids: [], mob_ids: [])
  end
end
