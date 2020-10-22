class CreatePokemons < ActiveRecord::Migration[6.0]
  def change
    create_table :pokemons do |t|
      t.string :name
      t.string :nickname
      t.string :kinds
      t.string :species
      t.integer :api_poke_id
    end
  end
end
