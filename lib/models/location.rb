class Location < ActiveRecord::Base
    has_many :events
    has_many :users, through: :events

    def self.names
        self.all.map do |location|
            location.name
        end
    end


end