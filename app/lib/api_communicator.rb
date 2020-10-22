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
    get_pokemon_name(api)
    get_pokemon_kinds(api)
    get_pokemon_species(api)
    get_pokemon_id(api)
end

def get_pokemon_name(api)
    puts api["name"]
end

def get_pokemon_kinds(api)
    puts api["types"][0]["type"]["name"]
end

def get_pokemon_species(api)
    puts api["species"]["name"]
end

def get_pokemon_id(api)
    puts api["id"]
end




