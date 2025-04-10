module CuentosHelper
  include UnlimitedCache

  def enlazar_nombres_conocidos(html)
    cuentos = cache_fetch "cuentos_nombre" do
      Cuento.select(:id, :nombre).index_by { |c| c.nombre.downcase }.transform_values(&:id)
    end

    return html if cuentos.empty?
    
    Rails.logger.debug "enlazar_nombres_conocidos: nombre_to_id: #{cuentos.inspect}"

    nombres_regex = cuentos.keys.map { |n| Regexp.escape(n) }.join("|")
    regex = /\b(#{nombres_regex})\b/ix

    html.gsub(regex) do |match|
      Rails.logger.debug "enlazar_nombres_conocidos: match: #{match.inspect}"
      %(<a href="/cuentos/#{cuentos[match.downcase]}">#{match}</a>)
    end.html_safe
  end

end
