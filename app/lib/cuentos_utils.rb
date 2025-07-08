module CuentosUtils
  
  def self.cuentos_regex(cuentos_source, exclude)
    cuentos =( exclude ?
      cuentos_source.where.not(id: exclude.id) :
      cuentos_source
    ).select(:id, :nombre).map{ |c| [c.nombre.downcase, c] }.to_h
    [cuentos, cuentos.empty? ? /a^/ :  /\b(#{cuentos.keys.map { |n| Regexp.escape(n) }.join("|")})\b/ix]
  end

end