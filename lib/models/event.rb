class Event < ActiveRecord::Base
    belongs_to :user
    belongs_to :location
    has_many :participants

    def self.upcoming_events
        self.all.map do |event|
            {name: "\n    #{event.name}".colorize(:blue) + " at " + "#{event.location.name}\n" + "    #{event.date.strftime("%B %d, %Y\n    %A %I:%M %p")}", value: event.id}
        end
    end

end