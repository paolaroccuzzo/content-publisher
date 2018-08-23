class AddImagesToDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :images, :json, default: []
  end
end
