class RenameMobsHasHabil < ActiveRecord::Migration[7.0]
  def change
    rename_table :mobsHasHabil, :mobs_has_habils
  end
end
