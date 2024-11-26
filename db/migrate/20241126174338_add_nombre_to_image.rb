class AddNombreToImage < ActiveRecord::Migration[7.0]
  def change
    add_column :images, :nombre, :string
  end
end
