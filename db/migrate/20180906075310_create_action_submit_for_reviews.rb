class CreateActionSubmitForReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :action_submit_for_reviews do |t|
      t.references :user, foreign_key: true
      t.references :document, foreign_key: true

      t.timestamps
    end
  end
end
