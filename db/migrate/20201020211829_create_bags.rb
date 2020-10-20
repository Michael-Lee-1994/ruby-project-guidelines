class CreateBags < ActiveRecord::Migration[6.0]
  def change
    create_table :bags do |t|
      t.string :ownersname
      t.string :item, default: "pokeball"
      t.integer :quantity, default: 15
      t.integer :user_id
    end
  end
end
