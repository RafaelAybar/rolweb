module CuentosUtils
  
  def self.cuentos_regex(cuentos_source)
    cuentos = cuentos_source.select(:id, :nombre).map{ |c| [c.nombre.downcase, c] }.to_h
    [cuentos, cuentos.empty? ? /a^/ :  /\b(#{cuentos.keys.map { |n| Regexp.escape(n) }.join("|")})\b/ix]
  end

end