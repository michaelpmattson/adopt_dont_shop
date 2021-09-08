require 'rails_helper'

RSpec.describe 'the admin shelters index' do
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

  it 'shows all shelters in reverse alphabetical order' do
    visit 'admin/shelters'

    within "#all-shelters" do
      expect(@shelter_2.name).to appear_before(@shelter_3.name)
      expect(@shelter_3.name).to appear_before(@shelter_1.name)
    end
  end

  it 'has a section for shelters w pending apps' do
    visit 'admin/shelters'

    within "#pending-shelters" do
      expect(page).to have_content(@shelter_1.name)
    end
  end

  it 'links to each admin show page from shelter names' do
    visit '/admin/shelters'
    within "#all-shelters" do
      click_link("Aurora shelter")
    end
    expect(current_path).to eq("/admin/shelters/#{@shelter_1.id}")

    visit '/admin/shelters'
    within "#all-shelters" do
      click_link("RGV animal shelter")
    end
    expect(current_path).to eq("/admin/shelters/#{@shelter_2.id}")

    visit '/admin/shelters'
    within "#all-shelters" do
      click_link("Fancy pets of Colorado")
    end
    expect(current_path).to eq("/admin/shelters/#{@shelter_3.id}")


    visit '/admin/shelters'
    within "#pending-shelters" do
      click_link("Aurora shelter")
    end
    expect(current_path).to eq("/admin/shelters/#{@shelter_1.id}")

    visit '/admin/shelters'
    within "#pending-shelters" do
      click_link("Fancy pets of Colorado")
    end
    expect(current_path).to eq("/admin/shelters/#{@shelter_3.id}")
  end
end
