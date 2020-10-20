class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :password
      t.integer :money, default: 5000
      t.integer :bag_id
    end
  end
end
