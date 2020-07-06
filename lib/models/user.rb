class User < ActiveRecord::Base 
    has_many :events
    has_many :locations, through: :events
    has_many :participants

    
    def self.register
        prompt= TTY::Prompt.new
        username = prompt.ask("Choose a username")
        name = prompt.ask("What is your name?")
        dob = self.ask_dob
        pswd = prompt.mask("Create a password")
        con_pswd = prompt.mask("Confirm password")
        if pswd == con_pswd
            puts "User created!"
            User.create(username:username, name: name, dob: dob, password: pswd)
            sleep(1)
        end
    end

    def self.ask_dob
        prompt= TTY::Prompt.new
        user_dob = prompt.ask("What is your date of birth? MM/DD/YYYY") do |question|
            question.validate (/\d{1,2}\/\d{1,2}\/\d{4}/)
        end
        dob = user_dob.split("/").map do |element|
            element.to_i
        end
        if !Date.valid_date?(dob[2], dob[0], dob[1])
            puts "Please enter a valid date of birth.".colorize(:red)
            self.ask_dob
        end
        if (Time.now.strftime('%Y%m%d').to_i - Time.new(dob[2], dob[0], dob[1]).strftime('%Y%m%d').to_i)/10000 < 18
            puts "Sorry, you must be 18 or older to join."
            sleep(2)
            interface = Interface.new()
            interface.welcome
            user_instance = interface.login_or_register
            interface.user = user_instance
            interface.main_menu
        else user_dob
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

