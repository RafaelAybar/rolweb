class CreateJoinTableCuentosMobs < ActiveRecord::Migration[7.0]
  def change
    create_join_table :cuentos, :mobs do |t|
      # t.index [:cuento_id, :mob_id]
      # t.index [:mob_id, :cuento_id]
    end
  end
end
