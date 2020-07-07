class LakeData


def self.get_data
response = RestClient.get("https://data.ny.gov/resource/mw8j-wduf.json")
data = JSON.parse(response)
ny_counties = data.select{|lake| lake["county"] == "Bronx" ||lake["county"] == "Kings"||lake["county"] == "Queens"||lake["county"] == "Richmond"||lake["county"] == "New York"}
lake_hashed = ny_counties.map{|lake_instance|{name: lake_instance["water"], acres_mile: lake_instance["acres_mile"], fish_species: lake_instance["fish_speci"], county: lake_instance["county"]}}
end
    

end