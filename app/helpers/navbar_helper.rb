module NavbarHelper
  include UnlimitedCache

  def navbar_cache_clases_ocultas
    cache_fetch "clases_ocultas" do
      Clase.where(oculto: true).order(:nombre).to_a
    end
  end

  def navbar_cache_clases_visibles
    cache_fetch "clases_visibles" do
      Clase.where(oculto: false).order(:nombre).to_a
    end
  end

  def navbar_cache_categorias
    cache_fetch "categorias" do
      Categ.order(:nombre).to_a
    end
  end
end
