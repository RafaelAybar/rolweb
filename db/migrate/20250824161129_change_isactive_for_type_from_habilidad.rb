class ChangeIsactiveForTypeFromHabilidad < ActiveRecord::Migration[7.0]
  def change
    add_column :habilidads, :tipo, :integer

    execute <<-SQL.squish
      UPDATE habilidads
      SET tipo = CASE
        WHEN isactive = FALSE THEN 1
        WHEN isactive = TRUE  THEN 0
        ELSE NULL
      END;
    SQL

    remove_column :habilidads, :isactive
  end
end
