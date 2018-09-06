class CreateActionPublishes < ActiveRecord::Migration[5.2]
  def change
    create_table :action_publishes do |t|
      t.references :user, foreign_key: true
      t.references :document, foreign_key: true
      t.text :change_note
      t.json :all_document_attributes
      t.boolean :with_review

      t.timestamps
    end
  end
end
