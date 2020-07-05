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

    def event_formatted(event)
        {name: "\n    #{event.name}".colorize(:blue) + " at " + "#{event.location.name}\n" + "    #{event.date.strftime("%A %B %d, %Y | %I:%M %p")}\n" + "    Organized by: #{event.user.name}\n" + "    Attending: #{event.participants.count}", value: event.id}
    end

    def no_created_events
        puts "You have no created events!".colorize(:red)
            sleep(1)
            main_menu
    end

    def show_all_my_events
        user.participants.reload.map do |participant|
            event_formatted(participant.event)
        end
    end
    
    def my_events
        system 'clear'
        if user.events.reload == []
            no_created_events
        else
            selected_event_id = prompt.select("Check event", show_all_my_events, per_page: 3)

            if Event.find_by(id: selected_event_id).user_id == user.id
                event = Event.find_by(id: selected_event_id)
                cancel_or_update?(event)
            else 
                if participant_actions == "Cancel Attendance"
                    Participant.cancel_attendance(user.id, selected_event_id)
                end
            end
            sleep(1)
            main_menu
        end
    end

    def participant_actions
        prompt.select("Cancel attendance?") do |menu|
            menu.choice "Cancel Attendance"
            menu.choice "Main Menu"
        end
    end

    def cancel_or_update?(event)
        prompt.select("Update or cancel event?") do |menu|
            menu.choice "Update Event", -> {update_event(event)}
            menu.choice "Cancel Event", -> {event.cancel_event?}
            menu.choice "Main Menu", -> {main_menu}
        end
    end

    def update_event(event)
        choice = prompt.select("What do you want to update") do |menu|
            menu.choice "Event Name", -> {event.update_event_name}
            menu.choice "Event Date", -> {event.update_date}
            menu.choice "Event Price", -> {event.update_price}
        end
    end

    def find_upcoming_events
        choices = prompt.multi_select("Sign up for event(s)", Event.upcoming_events)
        sign_up_to_event(choices)
        sleep(1)
        main_menu
    end

    def sign_up_to_event(choices)
        choices.each do |choice|
            Participant.create(event_id: choice, user_id: user.id)
        end
        puts "Sign up(s) successful! Can't wait to see you there!"
    end

end