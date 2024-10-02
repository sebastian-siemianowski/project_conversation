class CreateStatusChanges < ActiveRecord::Migration[7.0]
  def change
    create_table :status_changes do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status
      t.datetime :changed_at

      t.timestamps
    end
  end
end
