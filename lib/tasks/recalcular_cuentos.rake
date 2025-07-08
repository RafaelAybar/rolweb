namespace :cuentos do
  desc "Recalcula todas las referencias (parents/childs) de los cuentos"
  task recalcular_childs: :environment do
    puts "Recalculando referencias de cuentos..."

    cuentos_hash, regex = CuentosUtils.cuentos_regex(Cuento, false)

    Cuento.find_each do |cuento|
      cuento.childs.clear
      cuento.texto.body.to_html.scan(regex) do |match|
        referenced = cuentos_hash[match.first.downcase]
        next if referenced == cuento
        cuento.childs << referenced unless cuento.childs.include?(referenced)
      end
      cuento.save! if cuento.changed?
      puts "✅ Recalculado: #{cuento.nombre}"
    end

    puts "✅ Recalculado todo correctamente."
  end
end
