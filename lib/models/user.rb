class User < ActiveRecord::Base 
    has_many :events
    has_many :locations, through: :events
    has_many :participants

    @@prompt = TTY::Prompt.new(active_color: :cyan)

    def self.prompt
        @@prompt
    end
    
    def self.register
        name = self.register_name
        dob = self.register_dob
        username = self.register_username
        password = self.register_password
        self.successful_registration(username, name, dob, password)
    end

    def self.register_name
        self.prompt.ask("What is your name?\n") do |answer|
            answer.validate (/[a-zA-Z]+/)
            answer.messages[:valid?] = 'Please enter your name'.colorize(:red)
            answer.modify :capitalize
        end
    end
    
    def self.register_dob
        user_dob = self.prompt.ask("Date of birth? #{"Please enter in the following format: MM/DD/YYYY".colorize(:light_black)}\n") do |answer|
            answer.validate (/\d{1,2}\/\d{1,2}\/\d{4}/)
            answer.messages[:valid?] = 'Invalid date, try again'.colorize(:red)
        end
        dob = user_dob.split("/").map {|element| element.to_i}
        if !Date.valid_date?(dob[2], dob[0], dob[1])
            puts "Please enter a valid date of birth.".colorize(:red)
            self.register_dob
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

    def self.register_username
        username = self.prompt.ask("Create a Username #{"Must be 3 characters or greater and not contain and spaces or special characters".colorize(:light_black)}\n") do |answer|
            answer.validate (/\w{3,}/)
            answer.messages[:valid?] = 'Invalid username, try again'.colorize(:red)
        end
        if User.find_by(username: username) 
            puts "Username already taken!".colorize(:red)
            sleep(2)
            print "\r" + ("\e[A\e[K"*3)
            self.register_username
        end
        username
    end

    def self.register_password
        password = self.prompt.mask("Create a password", mask: "🐠")
        confirmed_password = self.prompt.mask("Confirm password", mask: "🐠")
        if password == confirmed_password
            password
        else
            puts "Passwords did not match, please try again.".colorize(:red)
            sleep(2)
            print "\r" + ("\e[A\e[K"*3)
            self.register_password
        end
    end

    def self.successful_registration(username, name, dob, password)
        puts "Account successfully created!".colorize(:cyan)
        sleep(2)
        User.create(username: username, name: name, dob: dob, password: password)
    end

    def self.login
        username = self.prompt.ask("What is your username?")
        pswd = prompt.mask("What is your password?")
        found_user = User.find_by(username: username, password:pswd)
        found_user ? found_user : self.incorrect_username_or_password
    end

    def self.incorrect_username_or_password
        puts "Incorrect username and/or password!".colorize(:red)
        self.login
    end

    def update_name 
        name_update = self.class.prompt.ask(" New name:")
        self.update(name: name_update)
        puts ColorizedString["Name has been updated to #{name_update}!"].green
    end

    def change_password
        current_pswd = self.class.prompt.mask("What is your current password?")
        new_pswd = self.class.prompt.mask("What is your new password?")
        confirm_new_pswd = self.class.prompt.mask("Please confirm new password")
        if current_pswd == self.password && new_pswd == confirm_new_pswd
            self.update(password: new_pswd)
            puts ColorizedString["Your password has been updated!"].green 
         else
            puts ColorizedString["Incorrect password  or new password does not match!"].red 
        end 
    
    end

     def delete_account
        self.class.prompt.warn("WARNING: Action can not be undone.")
        choice = self.class.prompt.select("Are you sure you want to delete this account") do |menu|
            menu.choice "Yes", -> {
                pswd = self.class.prompt.mask("What is your password?")
                if pswd == self.password
                    Participant.destroy_all_participants(self.id)
                    Event.erase_event(self.id)
                    self.destroy
                    new_inter = Interface.new
                    puts ColorizedString["ACCOUNT DESTROYED"].red 
                    sleep(3)
                    new_inter.welcome
                   new_inter.user = new_inter.login_or_register
                else
                    puts ColorizedString["Incorrect password"].red 
                end
                }
                menu.choice "No" 
            end
    end
     
end

