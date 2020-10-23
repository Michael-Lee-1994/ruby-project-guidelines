class AddingColumnToPokeballsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :pokeballs, :caught, :boolean
  end
end
