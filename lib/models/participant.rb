class Participant < ActiveRecord::Base
    belongs_to :event
    belongs_to :user

    def self.destroy_all_participants(selected_event_id)
        self.where(event_id: selected_event_id).find_each do |participant|
            participant.destroy
        end
    end

end