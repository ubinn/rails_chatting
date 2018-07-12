class CreateAdmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :admissions do |t|

      t.references    :chat_room
      t.references    :user
      
      t.boolean :ready_state, default: false, null: false 
      t.timestamps
    end
  end
end
