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
            user.my_events
        when "Find Upcoming Events"
            user.find_upcoming_events
        when "Create an Event"
            user.create_event
        when "Log out"
            interface = Interface.new()
            interface.welcome
            user_instance = interface.login_or_register
            interface.user = user_instance
        end
    end

    # --------------------

    def event_formatted(event)
        {name: "\n    #{event.name}".colorize(:blue) + " at " + "#{event.location.name}\n" + "    #{event.date.strftime("%B %d, %Y\n    %A %I:%M %p")}", value: event.id}
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
                user.update_event(selected_event_id)
            when "Cancel Event"
                user.cancel_event?(selected_event_id)
            else
                user.main_menu
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

end