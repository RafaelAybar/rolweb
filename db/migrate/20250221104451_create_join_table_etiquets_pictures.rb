class CreateJoinTableEtiquetsPictures < ActiveRecord::Migration[7.0]
  def change
    create_join_table :etiquets, :pictures do |t|
      t.index [:etiquet_id, :picture_id]
      t.index [:picture_id, :etiquet_id]
    end
  end
end
