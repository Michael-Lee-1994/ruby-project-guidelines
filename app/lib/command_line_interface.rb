
class CLI


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
            puts "Invalid input, try again."
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
            goodbye
            main_menu_validation = true
        else
            puts "Invalid number, try again!"
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
                6. Exit
            TEXT
end

def shop
    user_obj = User.find_by
end

def goodbye
    puts "Thanks for playing!"
end



end

