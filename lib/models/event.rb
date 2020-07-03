class Event < ActiveRecord::Base
    belongs_to :user
    belongs_to :location
    has_many :participants

    def self.upcoming_events
      self.all.map{|event|"#{event.name}, #{event.location.name}, $#{event.price}, #{event.date}"}
    end


end