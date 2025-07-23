class RenameTableCuentoRelationsToCuentoRelations < ActiveRecord::Migration[7.0]
  def change
    rename_table :table_cuento_relations, :cuento_relations
  end
end
