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
        Event.find(selected_event_id).destroy
        puts "Event canceled!".colorize(:red)
    end

end