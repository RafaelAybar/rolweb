class CuentosController < ModelController

  def initialize
    super 
    @tipo = Cuento
  end

  def create
    super {set_cuentos_childs}
  end

  def update
    super {set_cuentos_childs}
  end

  def model_params
    params.require(:cuento).permit(:nombre, :spoilers, :texto, :prioridad, :titulo)
  end

  private
  def set_cuentos_childs
    @x.childs.clear
    cuentos, regex = CuentosUtils.cuentos_regex(Cuento, @x)
    @x.texto.body.to_html.scan(regex) do |match|
      cuento = cuentos[match.first.downcase] 
      @x.childs << cuento unless @x.childs.include?(cuento)
    end.html_safe
  end

end
