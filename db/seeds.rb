User.destroy_all
Location.destroy_all
Event.destroy_all
Participant.destroy_all

u1 = User.create(name:"Jack", username:"jacksback",password: "123")
u2 = User.create(name:"Chris", username:"Fisherman",password: "Bass")
u3 = User.create(name:"Dereck", username:"FishDad",password: "2manyfish")


e1 = Event.create(name:"Fishing Competition",user_id: u3.id, location_id: 1, date: Time.new(2020,7,4,2), price: 5)
e2 = Event.create(name: "Fishing 6ft Apart",user_id: u2.id, location_id: 2, date: Time.new(2020,8,4,9), price: 5)
e3 = Event.create(name:"Father's day Fishing",user_id: u1.id, location_id: 0, date: Time.new(2020,9,4,6), price: 5)
e4 = Event.create(name:"Fish and Fashion",user_id: u1.id, location_id: 3, date: Time.new(2020,10,5,6), price: 10)

Participant.create(event_id: e1.id, user_id: u3.id)
Participant.create(event_id: e2.id, user_id: u2.id)
Participant.create(event_id: e3.id, user_id: u1.id)
Participant.create(event_id: e4.id, user_id: u1.id)
Participant.create(event_id: e1.id, user_id: u1.id)
Participant.create(event_id: e1.id, user_id: u2.id)
Participant.create(event_id: e2.id, user_id: u1.id)
Participant.create(event_id: e4.id, user_id: u2.id)
Participant.create(event_id: e4.id, user_id: u3.id)

# Location.create(LakeData.get_data)
LakeData.get_data.each{|lake| Location.create(lake)}