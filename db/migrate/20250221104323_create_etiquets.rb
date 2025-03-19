class CreateEtiquets < ActiveRecord::Migration[7.0]
  def change
    create_table :etiquets do |t|
      t.string :nombre
      t.string :color

      t.timestamps
    end
  end
end
