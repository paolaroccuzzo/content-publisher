# frozen_string_literal: true

class CreateHyperDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :hyper_documents do |t|
      t.string :content_id, null: false
      t.string :locale, null: false
      t.index %i[content_id locale], unique: true

      t.string :state, null: false

      t.integer :current_edition_number
      t.string :title
      t.string :document_type
      t.string :base_path

      t.json :contents, default: {}

      t.timestamps
    end
  end
end
