class Bag < ActiveRecord::Base
    belongs_to :user
    has_many :pokeballs
    has_many :pokemons, through: :pokeballs
end