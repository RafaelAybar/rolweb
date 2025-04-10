class AddPrioridadToCuento < ActiveRecord::Migration[7.0]
  def change
    add_column :cuentos, :prioridad, :integer
  end
end
