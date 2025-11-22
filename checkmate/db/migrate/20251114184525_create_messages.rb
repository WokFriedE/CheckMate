class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.bigint :msg_id
      t.string :from
      t.string :to
      t.timestamp :scheduled_send_time
      t.timestamp :send_time
      t.timestamp :receive_time
      t.timestamp :read_time
      t.text :msg_content
      t.string :msg_category

      t.timestamps
    end
  end
end
