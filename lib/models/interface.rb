class Interface 
    attr_accessor :prompt, :user

    def initialize 
        @prompt = TTY::Prompt.new(active_color: :cyan, symbols: {marker: '🐟'})
    end

    def welcome
        system 'clear'
        puts ColorizedString["      /`·.¸                                                          " ].light_white.on_cyan.blink
        puts ColorizedString["     ███████╗██╗███████╗██╗  ██╗██████╗ ██╗   ██╗████████╗███████╗   " ].light_white.on_cyan.blink
        puts ColorizedString[" ¸.·´██╔════╝██║██╔════╝██║  ██║██╔══██╗╚██╗ ██╔╝╚══██╔══╝██╔════╝   " ].light_white.on_cyan.blink
        puts ColorizedString[": © )█████╗  ██║███████╗███████║██████╔╝ ╚████╔╝    ██║   █████╗     " ].light_white.on_cyan.blink
        puts ColorizedString[" `·.¸██╔══╝¸.██║╚════██║██╔══██║██╔══██╗`·╚██╔╝    /██║¸  ██╔══╝     " ].light_white.on_cyan.blink
        puts ColorizedString["     ██║`´´  ██║███████║██║©)██║██████╔╝ ¸{██║    /¸██║¸`:███████╗   " ].light_white.on_cyan.blink
        puts ColorizedString["     ╚═╝     ╚═╝╚══════╝╚═╝·.╚═╝╚═════╝·´ `╚═╝¸.·´  ╚═╝ `·╚══════╝   " ].light_white.on_cyan.blink
        puts ColorizedString["          /`·.¸               `´´'¸.·´       : © ):´;      ¸  {      " ].light_white.on_cyan.blink
        puts ColorizedString["         /¸...¸`:·                            `·.¸ `·  ¸.·´ `·¸)     " ].light_white.on_cyan.blink
        puts ColorizedString["     ¸.·´  ¸   `·.¸.·´)                           `´´'¸.·´           " ].light_white.on_cyan.blink
    end

    def login_or_register
        answer = prompt.select("New user? or returning?") do |menu|
            menu.choice "Login", -> {User.login}
            menu.choice "Register", -> {User.register}
        end
    end

    def main_menu
        system 'clear'
        puts "Welcome #{user.username}!"
        choice = prompt.select("Main Menu") do |menu| 
            menu.choice "My Events", -> {my_events}
            menu.choice "Create an Event", -> {create_event}
            menu.choice "Find Upcoming Events", -> {find_upcoming_events}
            menu.choice "Settings", -> {settings}
            menu.choice "Log out", -> {log_out}
        end
    end

    def log_out
        interface = Interface.new()
        interface.welcome
        user_instance = interface.login_or_register
        interface.user = user_instance
        interface.main_menu
    end
    
    def my_events
        system 'clear'
        if user.events.reload == [] && user.participants.reload == []
            no_events
        else
            selected_event_id = prompt.select("Check event", all_events)

            if Event.find_by(id: selected_event_id).user_id == user.id
                event = Event.find_by(id: selected_event_id)
                event_menu(event)
            else 
                participant_actions(user.id, selected_event_id)
            end
            sleep(1)
            main_menu
        end
    end

    def no_events
        puts "You have no events!".colorize(:red)
        sleep(1)
        main_menu
    end
    
    def all_events
        user.participants.reload.map do |participant|
            event_formatted(participant.event)
        end
    end
    
    def event_formatted(event)
        {name: "  #{event.name.colorize(:light_yellow)} at #{event.location.name.colorize(:light_yellow)}\n    #{event.location.fish_species.colorize(:light_green)}\n    #{event.date.strftime("%b %d %Y")}  Attending: #{event.participants.count}  Acres: #{event.location.acres_mile}\n   #{event.date.strftime(" %a %I:%M%P")}  Price: $#{event.price}  By: #{event.user.name}   \n", value: event.id}
    end
    
    def participant_actions(user_id, selected_event_id)
        prompt.select("Cancel attendance?") do |menu|
            menu.choice "Cancel Attendance", -> {Participant.cancel_attendance(user_id, selected_event_id)}
            menu.choice "Main Menu", -> {main_menu}
        end
    end

    def event_menu(event)
        prompt.select("Event Menu") do |menu|
            menu.choice "Show Participants", -> {event.show_participants}
            menu.choice "Update Event", -> {update_event(event)}
            menu.choice "Cancel Event", -> {event.cancel_event?}
            menu.choice "Main Menu", -> {main_menu}
        end
    end

    def update_event(event)
        choice = prompt.select("What do you want to update?") do |menu|
            menu.choice "Event Name", -> {event.update_event_name}
            menu.choice "Event Date", -> {event.update_date}
            menu.choice "Event Price", -> {event.update_price}
        end
    end

    def find_upcoming_events
        if Event.upcoming_events(user).count > 0
            event_ids = prompt.multi_select("Sign up for event(s)", Event.upcoming_events(user), per_page: 4, echo:false)
            sign_up_to_event(event_ids)
        else puts "There are no new events near you!".colorize(:red)
        end
        sleep(2)
        main_menu
    end

    def sign_up_message(event_ids)
        puts "You have successfully signed up for: "
        event_ids.each do |event_id|
            puts "#{Event.find(event_id).name.colorize(:light_blue)}"
        end
    end

    def sign_up_to_event(event_ids)
        event_ids.each do |event_id|
            Participant.create(event_id: event_id, user_id: user.id)
        end
        sign_up_message(event_ids)
        sleep(1)
    end

    def create_event
           result = prompt.collect do
            key(:name).ask('Event Name:')
            key(:date).ask('Date: "MM/DD/YYYY":', convert: :string)
            key(:time).ask('Time of Event "HH:MM":',convert: :string)
            # binding.pry
            key(:price).ask('Price: $', convert: :int)
        end
        # binding.pry
        #convert time to string, reorganize the structure, convert to datetime
        split_date = result[:date].split("/")     
        add = split_date[2] + split_date[0] + split_date[1]
        # binding.pry
        final_date = add.to_datetime

        location_result = prompt.select("Please choose a location", Location.location_details)
        location_instance = Location.find_by(id: location_result)

        #### resul[:time] string to integer add to datetime 
        hour = result[:time].split(":")[0].to_i
        minute =result[:time].split(":")[1].to_i
        event_datetime = final_date.change(hour: hour, min: minute) #changes datetime's hour in create event
        
        # e1 = Event.create(name: result[:name], date: event_datetime, price: result[:price],user_id: user.id, location_id: location_instance.id)
        e1 = Event.create(name: result[:name], date: event_datetime, price: result[:price],user_id: user.id, location_id: location_instance.id)
        Participant.create(event_id: e1.id, user_id: user.id)
        # Event.participatns should = 1
        puts "NEW EVENT COMPLETED! Have fun at #{result[:name]}!".colorize(:green)
        sleep(3)
        main_menu
    end

    def settings
       var = prompt.select("What would you like to update?") do |menu|
            menu.choice "Name", -> {user.update_name}
            menu.choice "Password", -> {user.change_password}
            menu.choice "Delete Account", -> {user.delete_account}
            menu.choice "Main Menu", -> {main_menu}
        end
        sleep(3)
        main_menu
    end

end