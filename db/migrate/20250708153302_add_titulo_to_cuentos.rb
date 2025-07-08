class AddTituloToCuentos < ActiveRecord::Migration[7.0]
  def change
    add_column :cuentos, :titulo, :string
  end
end
