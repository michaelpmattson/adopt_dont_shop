require 'rails_helper'

RSpec.describe 'the admin shelters show page' do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

    @app_1 = Application.create!(name: "Cindy Lou Who", address: "123 Some Street", city: "Whoville", state: "WI", zip: "12345", description: "I'm a who for crying out loud.")
    @app_2 = Application.create!(name: "The Grinch", address: "2376 Mountaintop Drive", city: "Whoville", state: "WI", zip: "12345")

    @app_1.pets << @pet_1
    @app_2.pets << @pet_3

    @app_1.update(status: "Pending")
    @app_2.update(status: "Pending")
  end

  it 'has the shelters name and full address' do
    visit "/admin/shelters/#{@shelter_1.id}"
    expect(page).to have_content("Name: Aurora shelter")
    expect(page).to have_content("City: Aurora, CO")

    visit "/admin/shelters/#{@shelter_2.id}"
    expect(page).to have_content("Name: RGV animal shelter")
    expect(page).to have_content("City: Harlingen, TX")
  end

  it 'has a statistics section with average pet age' do
    visit "/admin/shelters/#{@shelter_1.id}"

    expect(page).to have_content("Statistics:")

    within "#statistics" do
      expect(page).to have_content("Average age: 4.33")
    end
  end
end
