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

    def event_formatted(event)
        {name: "\n    #{event.name}".colorize(:blue) + " at " + "#{event.location.name}\n" + "    #{event.date.strftime("%B %d, %Y\n    %A %I:%M %p")}", value: event.id}
    end
    
    
    def my_events
        system 'clear'
        prompt = TTY::Prompt.new
        if self.events == []
            puts "You have no created events!".colorize(:red)
            sleep(3)
            main_menu
        else
            show_my_events = self.events.map do |event|
                event_formatted(event)
            end
            selected_event_id = prompt.select("Check event", show_my_events)
            case cancel_or_update?
            when "Update Event"
                self.update_event(selected_event_id)
            when "Cancel Event"
                self.cancel_event?(selected_event_id)
            else
                self.main_menu
            end
        end
    end

    def cancel_or_update?
        prompt = TTY::Prompt.new
        prompt.select("Update or cancel event?") do |menu|
            menu.choice "Update Event"
            menu.choice "Cancel Event"
            menu.choice "Main Menu"
        end
    end

    def update_event(selected_event_id)
        prompt = TTY::Prompt.new
        choice = prompt.select("What do you want to update") do |menu|
            menu.choice "Event Name"
            menu.choice "Event Date"
            menu.choice "Event Price"
        end
        # add update price, name, and date
    end
    
    def cancel_event?(selected_event_id)
        prompt = TTY::Prompt.new
        choice = prompt.select("Are you sure you want to cancel this event?") do |menu|
            prompt.warn("WARNING: Action can not be undone.")
            menu.choice "Yes"
            menu.choice "No"
        end
        if choice == "Yes"
            Participant.destroy_all_participants(selected_event_id)
            Event.destroy_event(selected_event_id)
        end
        sleep(3)
        main_menu
    end
    
    def find_upcoming_events
        prompt = TTY::Prompt.new
        choices = prompt.multi_select("Sign up for event(s)", Event.upcoming_events)
        sign_up_to_event(choices)
        sleep(3)
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

