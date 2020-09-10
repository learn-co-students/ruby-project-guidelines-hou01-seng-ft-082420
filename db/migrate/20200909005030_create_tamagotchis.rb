class CreateTamagotchis < ActiveRecord::Migration[6.0]
  def change
    create_table :tamagotchis do |t|
      t.string :name 
      t.string :color
      t.boolean :alive
      t.integer :happiness 
    end
  end
end
