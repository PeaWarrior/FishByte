class Participant < ActiveRecord::Base
    belongs_to :event
    belongs_to :user

    def self.destroy_all_participants(selected_event_id)
        self.where(event_id: selected_event_id).find_each do |participant|
            participant.destroy
        end
    end

    def self.cancel_attendance(user_id, event_id)
        Participant.find_by(user_id: user_id, event_id: event_id).destroy
        puts "Canceled attendance!".colorize(:red)
    end

    def self.users(event)
        self.where(event_id: event.id).map do |participant|
            participant.user
        end
    end

    def self.participant_names(event)
        self.users(event).map do |user|
            user.id == event.user_id ? {name: "#{user.name + ' organizer'.colorize(:light_black)}", value: user.id} : {name: "#{user.name}", value: user.id}
        end
    end

end