require_relative 'api_communicator.rb'

class CLI

attr_accessor :current_user, :pokemon

def start
    welcome
    intro_prompt
end

def welcome
    puts "Welcome to the Pokemonlite CLI
    ".yellow
end

def intro_prompt
    puts "Do you have an account? 'Y' or 'N'".cyan
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
    puts "Please type in your username".cyan
    user_validation = false
    while user_validation == false do 
        username_input = gets.chomp.downcase
        user_obj = User.find_by(username:username_input)
        if user_obj && username_input == user_obj.username
            puts "Please type in your password".cyan
            password_validation = false
            while password_validation == false do
                password_input = gets.chomp.downcase
                if password_input == user_obj.password && username_input == user_obj.username
                    @current_user = username_input
                    password_validation = true
                    user_validation = true
                    main_menu
                else
                    puts "Sorry, invalid username or password. Please try again.".red
                end
            end
        else 
            puts "Invalid username, try again".red
            puts "
            Do you want to create an account? 'Yes'"
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
    puts "Redirecting to the log in 
    ".red 
    log_in
end

def main_menu
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
            main_menu_validation = true
            leave
        when 8
            delete_account
            main_menu_validation = true
        else
            invalid_input
        end
    end
end

def delete_account
    delete_validation = false
    delete_validation2 = false
    puts "Are you sure you want to delete your account? 'Yes, I do' or 'N'"
    while delete_validation == false do
        input = gets.chomp.downcase
        if input == "yes, i do"
            puts "Are you really really sure that you want to DELETE your account? :( 'Yes, I do!!! or 'N'"
            while delete_validation2 == false do
                input2 = gets.chomp.downcase
                if input2 == "yes, i do!!!"
                    user_obj = User.find_by(username:@current_user)
                    pokeballs = user_obj.bag.pokeballs
                    pokemon_objs = pokeballs.find_all do |p| p.pokemon.id end
                    array_ids = pokemon_objs.map do |p| p["pokemon_id"] end
                    array_ids.uniq
                    array_ids.each do |p| Pokemon.delete(p) end
                    user_obj.bag.pokeballs.destroy_all
                    user_obj.bag.destroy
                    user_obj.destroy
                    @current_user = ""
                    delete_validation = true
                    delete_validation2 = true
                    leave
                else
                    delete_validation = true
                    delete_validation2 = true
                    main_menu
                end
            end
        else
            delete_validation = true
            main_menu     
        end
    end
end


def main_menu_prompt
user_obj = User.find_by(username:@current_user)
puts "
Welcome #{user_obj.name.capitalize} to the main menu, what would you like to do?".yellow
puts <<-TEXT  

            1. Catch Pokemon
            2. My Pokemons
            3. My Bag
            4. My Money
            5. Shop
            6. Log Out
            7. Exit
            8. Delete Account
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
        users_bag.quantity = 0
        users_bag.save
        return false
    else
        return true
    end
end

def rand_int
    rand(10)+1
end

def pokeball_wiggle
    puts "      POKEBALL WIGGLES!!!

    ".yellow
end

def catch_pokemons
    user_obj = User.find_by(username: @current_user)
    bag_obj = Bag.find_by(user_id: user_obj.id)
    encounter_pokemon = get_random_api_pokemon
    poke_nickname = ""
    
    puts "Wild #{encounter_pokemon[:name].capitalize} APPEARED!
    ".light_cyan
    catch_pokemon_prompt
    catch_validation = false
    Pokemon.create(encounter_pokemon)
    created_pokemon_obj = Pokemon.last
    while catch_validation == false do
        input = gets.chomp.to_i
        # binding.pry
        if check_pokebowls(bag_obj) == true && input == 1
            temp = rand_int
            user_obj.bag.quantity -= 1
            user_obj.bag.save
            if temp > 6
                3.times{pokeball_wiggle}
                puts "You have successfully caught #{encounter_pokemon[:name].capitalize}!".light_magenta
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
                        poke_nickname = encounter_pokemon[:name]
                        catch_validation = true
                    else
                        invalid_input
                    end
                end
            created_pokemon_obj.nickname = poke_nickname
            created_pokemon_obj.save
            Pokeball.create(cost:200, kind:"pokeball", bag: bag_obj, pokemon: created_pokemon_obj, caught: true)  
            # binding.pry
            main_menu
            elsif temp <= 6 || temp >= 4
                2.times{pokeball_wiggle}
                puts "  Arg! SO CLOSE!!
                ".magenta
            Pokeball.create(cost:200, kind:"pokeball", bag: bag_obj, pokemon: created_pokemon_obj, caught: false)
                catch_pokemon_prompt 
            elsif temp <= 3 || temp >= 1
                puts "  OH NO! Pokemon has broke free!
                ".red
            Pokeball.create(cost:200, kind:"pokeball", bag: bag_obj, pokemon: created_pokemon_obj, caught: false)
                catch_pokemon_prompt
            else
                puts "This will never run"
            end
        elsif check_pokebowls(bag_obj) == false && input == 1
            catch_validation = true
            puts "Sorry, you have no pokeballs!".red
            puts "You have ran away".red
            
            main_menu
        elsif input == 2
            catch_validation = true
            puts "WHEW! Got away safely!".light_blue
            main_menu
        else
            invalid_input
        end
    end
end

def get_all_pokemons
    user_obj = User.find_by(username: @current_user)
    pokeballs_obj = user_obj.bag.pokeballs
    caught_array = pokeballs_obj.select do |p| p.pokemon_id if p.caught == true end
        #  binding.pry
    array_ids = caught_array.map do |p| p["pokemon_id"] end
    pokemons = array_ids.map do |p| Pokemon.find(p) end
    pokemons.each do|p| 
        if p.nickname == ""
            puts "#{p.name.capitalize} is a #{p.species.capitalize}.".light_magenta
        else
            puts "#{p.nickname.capitalize} is a #{p.species.capitalize}.".light_magenta
        end
    end
    
end


def my_pokemons
    puts "----My Pokemons----
    ".yellow
    get_all_pokemons
    main_menu
end

def my_bag
    user_obj = User.find_by(username: @current_user)
    if user_obj.bag.quantity < 0
        user_obj.bag.quantity = 0
        user_obj.bag.save
    end
    puts "
    You have #{user_obj.bag.quantity} #{user_obj.bag.item}(s) in your bag."
    main_menu
end

def my_money
    user_obj = User.find_by(username: @current_user)
    puts "
    You have $#{user_obj.money} left!"
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
    user_obj = User.find_by(username: @current_user)
    shop_validation = false
    while shop_validation == false do
        puts "
        How many pokeballs would you like to buy?
        "
        amount = gets.chomp.to_i
        if check_money(user_obj, amount) == true
            total = amount * 200
            money_left = user_obj.money - total
            user_obj.money = money_left
            user_obj.bag.quantity += amount
            user_obj.save
            user_obj.bag.save
            shop_validation = true
            main_menu
       end
    end
end

def log_out
    goodbye
    log_in
    
end

def goodbye
    @current_user = ""
    puts "Thanks for playing!"
end

def leave
    goodbye
    puts "Closing application".green
end

def invalid_input
    puts "Invalid input, please try again.".red
end

end
