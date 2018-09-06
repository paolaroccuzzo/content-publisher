class CreateActionEdits < ActiveRecord::Migration[5.2]
  def change
    create_table :action_edits do |t|
      t.references :user, foreign_key: true
      t.references :document, foreign_key: true
      t.json :changeset

      t.timestamps
    end
  end
end
