module CuentosHelper
  include UnlimitedCache

  def enlazar_nombres_conocidos(cuento)
    cache_fetch "cuentos_html_#{cuento.id}" do
      html=cuento.texto.body.to_html
      cuentos, regex = CuentosUtils.cuentos_regex(cuento.childs, cuento)
      html.gsub(regex) do |match|
        %(<a href="/cuentos/#{cuentos[match.downcase].id}">#{match}</a>)
      end.html_safe
    end
  end

end
