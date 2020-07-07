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

    def update_name 
        prompt = TTY::Prompt.new
        name_update = prompt.ask(" New name:")
        self.update(name: name_update)
        puts ColorizedString["Name has been updated to #{name_update}!"].green
      
    end

    def change_password
        prompt = TTY::Prompt.new
        current_pswd = prompt.mask("What is your current password?")
        new_pswd = prompt.mask("What is your new password?")
        confirm_new_pswd = prompt.mask("Please confirm new password")
        if current_pswd == self.password && new_pswd == confirm_new_pswd
            self.update(password: new_pswd)
            puts ColorizedString["Your password has been updated!"].green 

         else
            puts ColorizedString["Incorrect password  or new password does not match!"].red 
        
        end 
    
    end

     def delete_account
        prompt = TTY::Prompt.new
        prompt.warn("WARNING: Action can not be undone.")
        choice = prompt.select("Are you sure you want to delete this account") do |menu|
            menu.choice "Yes", -> {
               pswd = prompt.mask("What is your password?")
               if pswd == self.password
                self.destroy
                new_inter = Interface.new
                puts ColorizedString["ACCOUNT DESTROYED"].red 
                sleep(3)
                new_inter.welcome
                new_inter.login_or_register
            else
                puts ColorizedString["Incorrect password"].red 
               end
                }
                menu.choice "No" 
            end
    end
            
end

