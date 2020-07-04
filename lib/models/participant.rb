class Participant < ActiveRecord::Base
    belongs_to :event
    belongs_to :user

end