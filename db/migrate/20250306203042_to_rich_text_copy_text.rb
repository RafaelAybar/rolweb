class ToRichTextCopyText < ActiveRecord::Migration[7.0]
  def up
    {
      Item: [:efecto],
      Clase: [:efecto, :descripcion],
      Mob: [:cuerpo, :descripcion],
      Habilidad: [:efecto]
    }.each do |model, columns|
      model_class = model.to_s.constantize
      columns.each do |column|
        model_class.find_each do |record|
          record.update(column => record[column]) if record[column].present?
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
