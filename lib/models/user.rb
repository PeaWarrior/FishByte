class User < ActiveRecord::Base 
    has_many :events
    has_many :locations, through: :events
    has_many :participants

    
    def self.register
        prompt= TTY::Prompt.new
        username = prompt.ask("Choose a username")
        name = prompt.ask("What is your name?")
        age = prompt.ask("What is your age?")
        pswd = prompt.mask("Choose a password")
        con_pswd = prompt.mask("Confirm password")
        if pswd == con_pswd
            puts "User created!"
            User.create(username:username, name: name, age: age, password: pswd)
        end
    end
    
    def self.login
        prompt= TTY::Prompt.new
        username = prompt.ask("What is your username?")
        pswd = prompt.mask("What is your password?")
        found_user = User.find_by(username: username, password:pswd)
        if !found_user
            puts ColorizedString["Incorrect username and/or password!"].red
            self.login
        else
            found_user
        end
    end

    # not finished
    def create_event
        prompt = TTY::Prompt.new
        location_choice = prompt.select("Select location", Location.names)
    end





end

