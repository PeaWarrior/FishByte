class Location < ActiveRecord::Base
    has_many :events
    has_many :users, through: :events

    def self.names
        self.all.map do |location|
            location.name
        end
    end

    def self.location_details
        self.all.map{|location|  {name: "#{location.name.colorize(:light_yellow)}\n  #{location.fish_species.split(" - ").join(", ").colorize(:light_black)}\n  County: #{location.county}\n  Acres: #{location.acres_mile}\n", value: location.id}}
    end

end