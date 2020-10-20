class Pokeball < ActiveRecord::Base
    belongs_to :pokemon, optional: true
    belongs_to :bag
end