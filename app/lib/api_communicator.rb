require 'rest-client'
require 'json'
require 'pry'

def get_rand_number
   rand(151)+1
end

def pokemon_api
    rand = get_rand_number
    response_string = RestClient.get('https://pokeapi.co/api/v2/pokemon/'+rand.to_s)
    response_hash = JSON.parse(response_string)
end


def pokemon_info
    api = pokemon_api
    poke_hash = {name:get_pokemon_name(api), kinds: get_pokemon_kinds(api), species: get_pokemon_species(api), api_poke_id: get_pokemon_id(api)}
    poke_hash
end

def get_pokemon_name(api)
    api["name"]
end

def get_pokemon_kinds(api)
    api["types"][0]["type"]["name"]
end

def get_pokemon_species(api)
    api["species"]["name"]
end

def get_pokemon_id(api)
    api["id"]
end




