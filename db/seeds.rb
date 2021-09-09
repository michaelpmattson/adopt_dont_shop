# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Shelter.destroy_all
Application.destroy_all

shelter_1 = Shelter.create(name: 'Aurora shelter',         city: 'Aurora, CO',    foster_program: false, rank: 9)
shelter_2 = Shelter.create(name: 'RGV animal shelter',     city: 'Harlingen, TX', foster_program: false, rank: 5)
shelter_3 = Shelter.create(name: 'fancy pets of Colorado', city: 'Denver, CO',    foster_program: true,  rank: 10)

pet_1 =  shelter_1.pets.create(name: 'Lucille Bald', breed: 'sphynx',           age: 1, adoptable: true)
pet_2 =  shelter_3.pets.create(name: 'Lobster',      breed: 'doberman',         age: 3, adoptable: true)
pet_3 =  shelter_1.pets.create(name: 'Mr. Pirate',   breed: 'tuxedo shorthair', age: 5, adoptable: true)
pet_4 =  shelter_1.pets.create(name: 'Clawdia',      breed: 'shorthair',        age: 3, adoptable: true)
pet_5 =  shelter_3.pets.create(name: 'Lily',         breed: 'sphynx',           age: 8, adoptable: true)
pet_6 =  shelter_2.pets.create(name: 'Ann',          breed: 'ragdoll',          age: 5, adoptable: true)
pet_7 =  shelter_1.pets.create(name: 'Spiderman',    breed: 'chihuahua',        age: 4, adoptable: true)
pet_8 =  shelter_3.pets.create(name: 'Mr. Wiggles',  breed: 'unknown',          age: 6, adoptable: true)
pet_9 =  shelter_2.pets.create(name: 'Sunny',        breed: 'golden doodle',    age: 8, adoptable: true)
pet_10 = shelter_2.pets.create(name: 'Godzilla',     breed: 'ragdoll',          age: 4, adoptable: true)
pet_11 = shelter_3.pets.create(name: 'Pizzaface',    breed: 'corgi',            age: 2, adoptable: true)
pet_12 = shelter_1.pets.create(name: 'Precious',     breed: 'shorthair',        age: 1, adoptable: true)

cindy  = Application.create!(name: "Cindy Lou Who", address: "123 Some Street", city: "Chicago", state: "IL", zip: "12345", description: "I'm a who for crying out loud.")
grinch = Application.create!(name: "The Grinch", address: "2376 Mountaintop Drive", city: "Whoville", state: "WI", zip: "12345")
horton = Application.create!(name: "Horton", address: "7874 Hickory Lane", city: "Whoknows", state: "MA", zip: "48943")

app_pet_1 = ApplicationPet.create!(pet: pet_1, application: cindy)
app_pet_2 = ApplicationPet.create!(pet: pet_1, application: grinch)
app_pet_3 = ApplicationPet.create!(pet: pet_2, application: grinch)

cindy.update(status: "Pending")
