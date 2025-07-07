class CuentosController < ModelController

  def initialize
    super 
    @tipo = Cuento
  end

  def create
    set_cuentos_childs
    super
  end

  def update
    set_cuentos_childs
    super
  end

  def model_params
    params.require(:cuento).permit(:nombre, :spoilers, :texto, :prioridad)
  end

  private
  def set_cuentos_childs
    @x.childs.clear
    cuentos, regex = CuentosUtils.cuentos_regex(Cuento)
    @x.texto.body.to_html.scan(regex) do |match|
      cuento = cuentos[match.first.downcase] 
      @x.childs << cuento unless @x.childs.include?(cuento)
    end.html_safe
  end

end
