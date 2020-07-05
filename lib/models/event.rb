class Event < ActiveRecord::Base
    belongs_to :user
    belongs_to :location
    has_many :participants

    def self.upcoming_events
        self.all.map do |event|
            {name: "\n    #{event.name}".colorize(:blue) + " at " + "#{event.location.name}\n" + "    #{event.date.strftime("%B %d, %Y\n    %A %I:%M %p")}", value: event.id}
            binding.pry
        end
    end

    def self.destroy_event(selected_event_id)
        Event.find(selected_event_id).delete
        puts "Event canceled!".colorize(:red)
    end

    # Update event methods
    def update_event_name
        prompt = TTY::Prompt.new
        new_name = prompt.ask("New event name:")
        self.update(name: new_name)
    end

    def proposed_time(ask_date, new_time)
        Time.new(ask_date[0], ask_date[1], ask_date[2], new_time[0], new_time[1]).strftime("%B %d, %Y %A %I:%M %p")
    end

    def invalid_date
        puts "Please enter a valid date."
        sleep(1)
        self.update_date
    end

    def ask_date
        prompt = TTY::Prompt.new
        prompt.ask("Please enter a new date: YYYY/MM/DD") do |answer|
            answer.validate /[0-9]{4}\/[0-1][0-9]\/[0-3][0-9]/
        end.split("/")
    end
    
    def ask_time
        prompt = TTY::Prompt.new
        time = prompt.ask("Please enter new time in this format, HH:MM") do |answer|
            answer.validate /[0-2][0-9]\:[0-5][0-9]/
        end.split(":").map do |set|
            set.to_i
        end
    end

    def update_date
        new_time = proposed_time(ask_date, ask_time)
        new_time > Time.now ? self.update(date: new_time) : invalid_date
        puts "Event updated! #{self.date}"
        sleep (2)
    end

    def update_price
        prompt = TTY::Prompt.new
        new_price = prompt.ask("New price:") do |answer|
            answer.validate /[0-9]+$/
        end
        self.date > Time.now + 604800 ? self.update(price: new_price.to_i) : (puts "Unable to edit price 7 days before event.".colorize(:red))
    end


    def cancel_event?
        prompt = TTY::Prompt.new
        prompt.warn("WARNING: Action can not be undone.")
        choice = prompt.select("Are you sure you want to cancel this event?") do |menu|
            menu.choice "Yes", -> {
                Participant.destroy_all_participants(self.id)
                Event.destroy_event(self.id)
                }
            menu.choice "No"
        end
    end

end