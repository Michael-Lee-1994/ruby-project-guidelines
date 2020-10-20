class CreatePokeballs < ActiveRecord::Migration[6.0]
  def change
    create_table :pokeballs do |t|
      t.integer :cost
      t.string :kind
      t.integer :bag_id
      t.integer :pokemon_id, null: true
    end
  end
end
