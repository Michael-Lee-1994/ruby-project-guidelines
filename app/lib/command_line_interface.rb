require_relative 'api_communicator.rb'


class CLI

@@current_user = ""

def start
    welcome
    intro_prompt
end

def welcome
    puts "Welcome to the Pokemonlite CLI
    "
end

def intro_prompt
    puts "Do you have an account? 'Y' or 'N'"
    account_validation = false
    while account_validation == false do
        input = gets.chomp.downcase 
        if input.ord == 121
            account_validation = true
            log_in
        elsif input.ord == 110
            account_validation = true
            create_user
        else
            invalid_input
        end
    end
end


def log_in
    puts "Please type in your username"
    user_validation = false
    while user_validation == false do 
        username_input = gets.chomp.downcase
        user_obj = User.find_by(username:username_input)
        if user_obj && username_input == user_obj.username
            puts "Please type in your password"
            password_validation = false
           
            while password_validation == false do
                password_input = gets.chomp.downcase
                pass_obj = User.find_by(password:password_input)
                if password_input == pass_obj.password && username_input == user_obj.username
                    @@current_user = username_input
                    password_validation = true
                    user_validation = true
                    main_menu
                else
                    puts "Sorry, invalid username or password. Please try again."
                end
            end
        else 
            puts "Invalid username, try again"
            puts "Do you want to create an account? 'Yes'"
            puts "If not, re-type your username"
            if username_input == "yes"
                user_validation = true
                create_user
            end
        end
    end
end

def create_user_message
    puts "Let's create your account!
    "
end

def create_user
    create_user_message
    puts "Type in your username"
    username = gets.chomp.downcase
    puts "Type in your password"
    password = gets.chomp.downcase
    puts "Type in your character name"
    name = gets.chomp.downcase
    new_user = User.create(name:name, username: username, password:password)
    new_bag = Bag.create(ownersname: "#{name}'s bag", user: new_user)
    Pokeball.create(cost:200, kind:"pokeball", bag: new_bag)
    log_in
end

def main_menu
    binding.pry
    main_menu_prompt
    main_menu_validation = false
    while main_menu_validation == false do
        input = gets.chomp.to_i
        
        case input
        when 1 
            catch_pokemons
            main_menu_validation = true
        when 2
            my_pokemons
            main_menu_validation = true
        when 3
            my_bag
            main_menu_validation = true
        when 4
            my_money
            main_menu_validation = true
        when 5
            shop 
            main_menu_validation = true
        when 6
            log_out
            main_menu_validation = true
        when 7
            leave
            main_menu_validation = true
        else
            invalid_input
        end
    end

    
end

def main_menu_prompt
    puts <<-TEXT  
            Welcome to the main menu, what would you like to do?
                1. Catch Pokemon
                2. My Pokemons
                3. My Bag
                4. My Money
                5. Shop
                6. Log Out
                7. Exit
            TEXT
end

def get_random_api_pokemon
    api_poke = pokemon_info
    api_poke
end

def catch_pokemon_prompt
puts <<-TEXT
        What would you like to do?
        1. Throw a Pokeball
        2. Run away
        TEXT
    end
    
def check_pokebowls(users_bag)
    bowls_left = users_bag.quantity - 1
    if bowls_left <= 0
        return false
    else
        return true
    end
end

def rand_int
    rand(10)+1
end

def pokeball_wiggle
    puts "POKEBALL WIGGLES!!!"
end

def catch_pokemons
    user_obj = User.find_by(username: @@current_user)
    bag_obj = Bag.find_by(user_id: user_obj.id)
    encounter_pokemon = get_random_api_pokemon
    poke_name = encounter_pokemon[0]
    poke_kinds = encounter_pokemon[1]
    poke_species = encounter_pokemon[2]
    poke_id = encounter_pokemon[3]
    poke_nickname = ""
    
    puts "Wild #{poke_name} appeared!
    "
    catch_pokemon_prompt
    catch_validation = false
    while catch_validation == false do
        input = gets.chomp.to_i
        if check_pokebowls(bag_obj) == true && input == 1
            temp = rand_int
            bag_obj.quantity -= 1
            bag_obj.save
            if temp > 6
                3.times{pokeball_wiggle}
                puts "You have successfully caught #{poke_name}!"
                puts "Would you like to name your pokemon? 'Y' or 'N'"
                name_validation = false
                while name_validation == false do
                input = gets.chomp.downcase
                    if input == "y"
                        puts "What would you like to name your pokemon?"
                        nickname = gets.chomp.downcase
                        name_validation = true
                        poke_nickname = nickname
                        catch_validation = true
                    elsif input == "n"
                        name_validation = true
                        catch_validation = true
                    else
                        invalid_input
                    end
                end
            pokemon = Pokemon.create(name:poke_name, nickname: poke_nickname, kinds: poke_kinds, species: poke_species, api_poke_id: poke_id) 
            pokeball = Pokeball.create(cost:200, kind:"pokeball", bag: bag_obj, pokemon: pokemon)  
            main_menu
            elsif temp <= 6 || temp >= 4
                2.times{pokeball_wiggle}
                puts "Arg! SO CLOSE!!"
                catch_pokemon_prompt
                
            else 
                puts "OH NO! Pokemon has broke free!"
                catch_pokemon_prompt
            end


        elsif check_pokebowls(bag_obj) == false && input == 1
            puts "Sorry, you have no pokeballs!"

        elsif input == 2
            puts "Got away safely!"
            main_menu
        else
            invalid_input
        end
    end


end

def get_all_pokemons
    user_obj = User.find_by(username: @@current_user)
    bag_obj = Bag.find_by(user_id: user_obj.id)
    pokemons = bag_obj.pokemons
    pokemon_names = []
    pokemons.map do|p| 
        if p.nickname == ""
            pokemon_names << "#{p.name.capitalize} is a #{p.species.capitalize}."
        else
            pokemon_names << "#{p.nickname.capitalize} is a #{p.species.capitalize}."
        end
    end
    puts pokemon_names
end


def my_pokemons
    puts "----My Pokemons----"
    get_all_pokemons
    main_menu
end

def my_bag
    user_obj = User.find_by(username: @@current_user)
    bag_obj = Bag.find_by(user_id: user_obj.id)
    puts "You have #{bag_obj.quantity} #{bag_obj.item}(s) in your bag."
    main_menu
end

def my_money
    user_obj = User.find_by(username: @@current_user)
    puts "You have $#{user_obj.money} left!"
    main_menu
end

def check_money(user, amount)
    total = amount * 200
    money_left = user.money - total
    if money_left < 0
        puts "You have insufficient money!"
        return false
    else
        puts "Thanks for the purchase! You have $#{money_left} left."
        return true
    end
end


def shop
    user_obj = User.find_by(username: @@current_user)
    bag_obj = Bag.find_by(user_id: user_obj.id)
    shop_validation = false
    while shop_validation == false do
        puts "How many pokeballs would you like to buy?"
        amount = gets.chomp.to_i
        if check_money(user_obj, amount) == true
            total = amount * 200
            money_left = user_obj.money - total
            shop_validation = true
            user_obj.money = money_left
            user_obj.save
            bag_obj.quantity += amount
            bag_obj.save
            main_menu
       end
    end
end


def log_out
    goodbye
    log_in
    
end

def goodbye
    @@current_user = ""
    puts "Thanks for playing!"
end

def leave
    goodbye
    puts "Closing application"
end

def invalid_input
    puts "Invalid input, please try again."
end



end
