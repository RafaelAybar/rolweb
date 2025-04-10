class CreateCuentos < ActiveRecord::Migration[7.0]
  def change
    create_table :cuentos do |t|
      t.string :nombre
      t.boolean :spoilers

      t.timestamps
    end
  end
end
