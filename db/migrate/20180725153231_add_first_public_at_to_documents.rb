class AddFirstPublicAtToDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :first_public_at, :datetime
  end
end
