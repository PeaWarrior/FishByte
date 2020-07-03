User.destroy_all
Location.destroy_all
Event.destroy_all

u1 = User.create(name:"Jack", age: 27, username:"jacksback",password: "123")
u2 = User.create(name:"Chris", age: 26, username:"Fisherman",password: "Bass")
u3 = User.create(name:"Dereck", age: 57, username:"FishDad",password: "2manyfish")

l1 = Location.create(name:"Central Park",water:"Freshwater", acres_mile: 2344, fish_species: "Blue Gil")
l2 = Location.create(name:"Van Courtland",water:"Freshwater", acres_mile: 344, fish_species: "Cat Fish")
l3 = Location.create(name:"Fresh Kills",water:"Saltwater", acres_mile: 8344, fish_species: "Shark")

e1 = Event.create(name:"Fishing Competition",user_id: u3.id, location_id: l3.id, date: Time.new(2020,7,4,2), price: 5)
e2 = Event.create(name: "Fishing 6ft Apart",user_id: u2.id, location_id: l1.id, date: Time.new(2020,8,4,9), price: 5)
e3 = Event.create(name:"Father's day Fishing",user_id: u1.id, location_id: l2.id, date: Time.new(2020,9,4,6), price: 5)
e4 = Event.create(name:"Fish and Fashion",user_id: u1.id, location_id: l1.id, date: Time.new(2020,10,5,6), price: 10)