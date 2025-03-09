class ToRichTextRemoveUnusedColumns < ActiveRecord::Migration[7.0]
  def up
    {
      Item: [:efecto],
      Clase: [:efecto, :descripcion],
      Mob: [:cuerpo, :descripcion],
      Habilidad: [:efecto]
    }.each do |model, columns|
      model_class = model.to_s.constantize
      columns.each do |column|
        remove_column model_class.table_name, column
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end