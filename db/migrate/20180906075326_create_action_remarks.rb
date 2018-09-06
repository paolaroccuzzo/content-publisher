class CreateActionRemarks < ActiveRecord::Migration[5.2]
  def change
    create_table :action_remarks do |t|
      t.references :user, foreign_key: true
      t.references :document, foreign_key: true
      t.text :message

      t.timestamps
    end
  end
end
