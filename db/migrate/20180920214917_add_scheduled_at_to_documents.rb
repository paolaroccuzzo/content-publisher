class AddScheduledAtToDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :scheduled_at, :datetime
  end
end
