module CuentosUtils
  
  def self.cuentos_regex(cuentos_source, exclude)
    cuentos = cuentos_source.where.not(id: exclude.id).select(:id, :nombre).map{ |c| [c.nombre.downcase, c] }.to_h
    [cuentos, cuentos.empty? ? /a^/ :  /\b(#{cuentos.keys.map { |n| Regexp.escape(n) }.join("|")})\b/ix]
  end

end