class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.integer :user_id
      t.integer :tamagotchi_id
    end
  end
end
