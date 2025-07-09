class CreateJoinTableCuentosPictures < ActiveRecord::Migration[7.0]
  def change
    create_join_table :cuentos, :pictures do |t|
      t.index [:cuento_id, :picture_id]
      # t.index [:picture_id, :cuento_id]
    end
  end
end
