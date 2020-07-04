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
            new_user = User.create(username:username, name: name, age: age, password: pswd)
            new_user.main_menu
        end
    end
    
    def self.login
        prompt= TTY::Prompt.new
        username = prompt.ask("What is your username?")
        pswd = prompt.mask("What is your password?")
        user_check = User.find_by(username: username, password:pswd)
        if !user_check
            puts ColorizedString["Incorrect username and/or password!"].red
            self.login
        else 
            user_check.main_menu
        end
    end
    
    def main_menu
        system 'clear'
        puts "Welcome #{self.username}!"
        prompt = TTY::Prompt.new
        choice = prompt.select("Main Menu") do |menu| 
            menu.choice "My Events"
            menu.choice "Create an Event"
            menu.choice "Find Upcoming Events"
            menu.choice "Log out"
        end
        
        case choice
        when "My Events"
            self.my_events
        when "Find Upcoming Events"
            self.find_upcoming_events
        when "Create an Event"
            self.create_event
        when "Log out"
            interface = Interface.new()
            interface.welcome
            interface.login_or_register
        end
    end
    
    
    def my_events
        system 'clear'
        prompt = TTY::Prompt.new
        if self.events = []
            puts "You have no created events!".colorize(:red)
            main_menu
        else
            show_my_events = self.events.map do |event|
                {name: "\n    #{event.name}".colorize(:blue) + " at " + "#{event.location.name}\n" + "    #{event.date.strftime("%B %d, %Y\n    %A %I:%M %p")}", value: event.id}
            end
            selected_event = prompt.select("Check event", show_my_events)
            cancel_event?(selected_event)
        end
    end
    
    def cancel_event?(selected_event)
        prompt = TTY::Prompt.new
        choice = prompt.select("Do you want to cancel this event?") do |menu|
            prompt.warn("WARNING: Action can not be undone.")
            menu.choice "Yes"
            menu.choice "No"
        end
        case choice
        when "Yes"
            Participant.where(event_id: selected_event).find_each do |participant|
                participant.destroy
            end
            event = Event.find(selected_event)
            event.destroy
            puts "Event canceled!"
        else
            main_menu
        end
        main_menu
    end
    
    def find_upcoming_events
        prompt = TTY::Prompt.new
        choices = prompt.multi_select("Sign up for event(s)", Event.upcoming_events)
        sign_up_to_event(choices)
        main_menu
    end
    
    def sign_up_to_event(choices)
        choices.each do |choice|
            Participant.create(event_id: choice, user_id: self.id)
        end
        puts "Sign up(s) successful! Can't wait to see you there!"
    end

    # not finished
    def create_event
        prompt = TTY::Prompt.new
        location_choice = prompt.select("Select location", Location.names)
    end





end

