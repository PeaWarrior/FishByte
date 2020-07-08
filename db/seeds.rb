User.destroy_all
Location.destroy_all
Event.destroy_all
Participant.destroy_all


10.times do
    User.create(name: Faker::TvShows::TheFreshPrinceOfBelAir.unique.character, dob: Faker::Date.birthday, username: Faker::Internet.user_name, password: Faker::Internet.password)
end 
10.times do
    User.create(name: Faker::Name.name, dob: Faker::Date.birthday, username: Faker::Internet.user_name, password: Faker::Internet.password)
end

LakeData.get_data.each{|lake| Location.create(lake)}

10.times do
    Event.create(name: Faker::Space.unique.nasa_space_craft+' Fishing',price: rand(300), user_id: rand(1..20), date:Faker::Date.forward(days = 365), location_id: rand(1..12))
end

50.times do 
Participant.create(event_id: rand(1..10), user_id: rand(1..20))
end