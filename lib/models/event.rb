class Event < ActiveRecord::Base
    belongs_to :user
    belongs_to :location
    has_many :participants

    @@prompt = TTY::Prompt.new(active_color: :cyan, symbols: {marker: '🐟', radio_on: '🎣', radio_off: ' '}, quiet: false)

    def self.prompt
        @@prompt
    end

    def self.event_view_format(event)
        {name: "#{event.name.colorize(:light_yellow)} at #{event.location.name}, #{event.location.county}\n     #{event.location.fish_species.split(" - ").join(", ").colorize(:light_blue)}\n     #{"by #{event.user.name}".colorize(:light_black)}\n     #{event.date.strftime("%b %d %Y")}  Attending: #{event.participants.count}  Size: #{event.location.acres_mile} acres\n    #{event.date.strftime(" %a %I:%M%P")}  Price: $#{event.price}\n", value: event.id}
    end

    def self.upcoming_events(user_instance)
        self.unregistered_events(user_instance).map do |event|
            self.event_view_format(event)
        end
    end

    def self.unregistered_events(user)
        self.order(:date).select do |event|
            !Participant.find_by(event_id: event.id, user_id: user.id)
        end
    end

    def self.destroy_event(event)
        Event.find(event.id).delete
    end

    # UPDATE EVENT METHODS START

    def update_event_name
        new_name = self.class.prompt.ask("New event name:")
        self.update(name: new_name)
    end

    def update_date_and_time
        self.update(date: "#{get_new_date} #{get_new_time}".to_datetime)
        puts "Updated #{self.name.colorize(:cyan)} date & time to #{self.date}!"
        sleep(2)
    end

    def get_new_date
        new_date = self.class.prompt.ask("Please enter a date: #{"Please enter date in the following format: MM/DD/YYYY".colorize(:light_black)}") do |answer|
            answer.validate /[0-1][0-9]\/[0-3][0-9]\/[0-9]{4}/
            answer.messages[:valid?] = "Invalid date"
        end
        self.valid_new_date?(new_date)
    end

    def valid_new_date?(new_date)
        new_date_array = new_date.split("/").map {|element| element.to_i}
        if Date.valid_date?(new_date_array[2], new_date_array[0], new_date_array[1])
            if new_date.to_datetime > Time.new
                new_date
            else
                puts "Date entered is a past date, please enter a valid date".colorize(:red)
                self.get_new_date
            end
        else
            puts "Please enter a valid date".colorize(:red)
        end
    end

    def get_new_time
        self.class.prompt.ask("Please enter a new time: #{"Please enter a new time in the following format: HH:MM am/pm".colorize(:light_black)}") do |answer|
            answer.validate /[0-2][0-9]\:[0-5][0-9]/
            answer.messages[:valid?] = "Invalid time"
        end
    end

    def update_price
        new_price = self.class.prompt.ask("New price:") do |answer|
            answer.validate /[0-9]+$/
            answer.messages[:valid?] = 'Enter a valid price'
        end
        self.date > Time.now + 604800 ? self.update(price: new_price.to_i) : (puts "Unable to edit price 7 days before event.".colorize(:red))
    end

    def event_info
        {name: "  #{self.name.colorize(:light_yellow)} at #{self.location.name.colorize(:light_yellow)}\n    #{self.location.fish_species.colorize(:light_green)}\n    #{self.date.strftime("%b %d %Y")}  Attending: #{self.participants.count}  Acres: #{self.location.acres_mile}\n   #{self.date.strftime(" %a %I:%M%P")}  Price: $#{self.price}  By: #{self.user.name}   \n", value: self.id}
    end

    def update_location
        new_location = self.class.prompt.select("Select a new location for:\n  #{self.event_info[:name]}", Location.location_details)
        self.update(location: new_location.id)
    end

    # UPDATE EVENT METHODS END

    def cancel_event?
        puts "WARNING: Action can not be undone.".colorize(:yellow)
        self.class.prompt.select("Are you sure you want to cancel this event?") do |menu|
            menu.choice "Yes", -> {cancel_event_confirmed}
            menu.choice "No"
        end
    end

    def cancel_event_confirmed
        Participant.destroy_participants_by_event(self)
        Event.destroy_event(self)
        puts "Event canceled!".colorize(:red)
    end

    def show_participants
        self.class.prompt.select("Participants:", Participant.participant_names(self), per_page: 10)
    end

    def self.destroy_events_by_user(user)
        self.where(user_id: user.id).each do |event| 
            Event.destroy_event(event)
        end
    end

end