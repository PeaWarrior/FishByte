class Interface 
    attr_accessor :prompt, :user

    def initialize 
        @prompt = TTY::Prompt.new
    end

    def welcome
        system 'clear'
        puts ColorizedString["      /`·.¸                                                          " ].white.on_light_blue.blink
        puts ColorizedString["     ███████╗██╗███████╗██╗  ██╗██████╗ ██╗   ██╗████████╗███████╗   " ].white.on_light_blue.blink
        puts ColorizedString[" ¸.·´██╔════╝██║██╔════╝██║  ██║██╔══██╗╚██╗ ██╔╝╚══██╔══╝██╔════╝   " ].white.on_light_blue.blink
        puts ColorizedString[": © )█████╗  ██║███████╗███████║██████╔╝ ╚████╔╝    ██║   █████╗     " ].white.on_light_blue.blink
        puts ColorizedString[" `·.¸██╔══╝¸.██║╚════██║██╔══██║██╔══██╗`·╚██╔╝    /██║¸  ██╔══╝     " ].white.on_light_blue.blink
        puts ColorizedString["     ██║`´´  ██║███████║██║©)██║██████╔╝ ¸{██║    /¸██║¸`:███████╗   " ].white.on_light_blue.blink
        puts ColorizedString["     ╚═╝     ╚═╝╚══════╝╚═╝·.╚═╝╚═════╝·´ `╚═╝¸.·´  ╚═╝ `·╚══════╝   " ].white.on_light_blue.blink
        puts ColorizedString["          /`·.¸               `´´'¸.·´       : © ):´;      ¸  {      " ].white.on_light_blue.blink
        puts ColorizedString["         /¸...¸`:·                            `·.¸ `·  ¸.·´ `·¸)     " ].white.on_light_blue.blink
        puts ColorizedString["     ¸.·´  ¸   `·.¸.·´)                           `´´'¸.·´           " ].white.on_light_blue.blink
        
    end

    def login_or_register
        answer = prompt.select("New user? or returning?", [
            "Login",
            "Register"
        ])
        
        if answer == "Login"
            User.login 
        elsif answer == "Register"
            User.register
        end
    end

    def main_menu
        system 'clear'
        puts "Welcome #{user.username}!"
        choice = prompt.select("Main Menu") do |menu| 
            menu.choice "My Events"
            menu.choice "Create an Event"
            menu.choice "Find Upcoming Events"
            menu.choice "Log out"
        end
        
        case choice
        when "My Events"
            my_events
        when "Find Upcoming Events"
            find_upcoming_events
        when "Create an Event"
            create_event
        when "Log out"
            interface = Interface.new()
            interface.welcome
            user_instance = interface.login_or_register
            interface.user = user_instance
        end
    end


    # --------------------

    def event_formatted(event)
        {name: "\n    #{event.name}".colorize(:blue) + " at " + "#{event.location.name}\n" + "    #{event.date.strftime("%B %d, %Y\n      %A %I:%M %p")}", value: event.id}
    end
    
    def my_events
        system 'clear'
        if user.events == []
            puts "You have no created events!".colorize(:red)
            sleep(3)
            main_menu
        else
            show_my_events = user.events.map do |event|
                event_formatted(event)
            end
            selected_event_id = prompt.select("Check event", show_my_events)
            case cancel_or_update?
            when "Update Event"
                update_event(selected_event_id)
            when "Cancel Event"
                cancel_event?(selected_event_id)
            else
                main_menu
            end
        end
    end

    def cancel_or_update?
        prompt.select("Update or cancel event?") do |menu|
            menu.choice "Update Event"
            menu.choice "Cancel Event"
            menu.choice "Main Menu"
        end
    end

    def update_event(selected_event_id)
        choice = prompt.select("What do you want to update") do |menu|
            menu.choice "Event Name"
            menu.choice "Event Date"
            menu.choice "Event Price"
        end
        # add update price, name, and date
    end

    def cancel_event?(selected_event_id)
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
        choices = prompt.multi_select("Sign up for event(s)", Event.upcoming_events)
        sign_up_to_event(choices)
        sleep(3)
        main_menu
    end

    def sign_up_to_event(choices)
        choices.each do |choice|
            Participant.create(event_id: choice, user_id: user.id)
        end
        puts "Sign up(s) successful! Can't wait to see you there!"
    end

    def create_event
           result = prompt.collect do
            key(:name).ask('Event Name:')
            key(:date).ask('Date:', value: "DD/MM/YYYY", convert: :datetime)
            key(:time).ask('Time of Event:',value: "HH:MM", convert: :string)
            # binding.pry
            key(:price).ask('Price: $', convert: :int)
        end
        location_result = prompt.select("Please choose a location", Location.names)
        location_instance = Location.find_by(name: location_result)

        #### resul[:time] string to integer add to datetime 
        hour = result[:time].split(":")[0].to_i
        minute =result[:time].split(":")[1].to_i
        event_datetime = result[:date].change(hour: hour, min: minute) #changes datetime's hour in create event
        # 
        
        e1 = Event.create(name: result[:name], date: event_datetime, price: result[:price],user_id: user.id, location_id: location_instance.id)
        Participant.create(event_id: e1.id, user_id: user.id)
        # Event.participatns should = 1
        puts "NEW EVENT COMPLETED! Have fun at #{result[:name]} event!!!".colorize(:green)
    end
    
end