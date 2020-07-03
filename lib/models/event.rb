class Event < ActiveRecord::Base
belongs_to :users
belongs_to :locations
end