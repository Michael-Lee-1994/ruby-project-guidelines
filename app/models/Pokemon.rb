class Pokemon < ActiveRecord::Base
    has_many :pokeballs
    has_many :bags, through: :pokeballs
end