class RemoveColumnNameFromTableName < ActiveRecord::Migration[8.0]
  def change
    remove_column :Organizations, :org_id, :integer
  end
end
