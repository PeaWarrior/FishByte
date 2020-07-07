class Location < ActiveRecord::Base
    has_many :events
    has_many :users, through: :events

    def self.names
        self.all.map do |location|
            location.name
        end
    end

    def self.location_details
        self.all.map{|location|  {name: "#{location.name}     Acres: #{location.acres_mile} \n  #{location.fish_species}\n ",value: location.id}}
    end

end