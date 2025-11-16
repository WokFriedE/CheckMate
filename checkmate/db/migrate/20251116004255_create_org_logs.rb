class CreateOrgLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :org_logs do |t|
      t.uuid :user_id
      t.integer :org_id
      t.text :operation
      t.timestamp :time

      t.timestamps
    end
  end
end
