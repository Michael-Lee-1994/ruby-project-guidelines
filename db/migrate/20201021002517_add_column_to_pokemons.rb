class AddColumnToPokemons < ActiveRecord::Migration[6.0]
  def change
    add_column :pokemons, :api_poke_id, :integer
  end
end
