class CreateJoinTableCuentosEtiquets < ActiveRecord::Migration[7.0]
  def change
    create_join_table :cuentos, :etiquets do |t|
      t.index [:cuento_id, :etiquet_id]
      # t.index [:etiquet_id, :cuento_id]
    end
  end
end
