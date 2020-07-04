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

end