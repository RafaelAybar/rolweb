module ApplicationHelper

  def main_cuento_path
    cache_fetch "cuento_first" do
      cuento = Cuento.order(prioridad: :desc).first
      cuento.present? ? cuento_path(cuento) : "#"
    end
  end
  
  def importJS (module_name)
    content_for :head do
      javascript_import_module_tag(module_name)
    end
  end

  def only_admin_content(&block)
    if session[:admin]
      yield
    end
  end
  
end
