require 'rails_helper'

RSpec.describe 'the admin applications show page' do
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

    @application_pet_1 = ApplicationPet.create!(pet: @pet_1, application: @app_1)
    @application_pet_2 = ApplicationPet.create!(pet: @pet_4, application: @app_1)
    @application_pet_3 = ApplicationPet.create!(pet: @pet_3, application: @app_2)

    @app_1.update(status: "Pending")
    @app_2.update(status: "Pending")
  end

  it 'there are buttons to approve each pet on the app' do
    visit "/admin/applications/#{@app_1.id}"

    within "#pet-#{@pet_1.id}" do
      click_button("Approve")
    end

    expect(current_path).to eq("/admin/applications/#{@app_1.id}")

    within "#pet-#{@pet_1.id}" do
      expect(page).to_not have_button("Approve")
      expect(page).to     have_content("Approved")
    end

    within "#pet-#{@pet_4.id}" do
      expect(page).to have_button("Approve")
    end
  end
end


# Approving a Pet for Adoption
#
# As a visitor
# When I visit an admin application show page ('/admin/applications/:id')
# For every pet that the application is for, I see a button to approve the application for that specific pet
# When I click that button
# Then I'm taken back to the admin application show page
# And next to the pet that I approved, I do not see a button to approve this pet
# And instead I see an indicator next to the pet that they have been approved




# Rejecting a Pet for Adoption
#
# As a visitor
# When I visit an admin application show page ('/admin/applications/:id')
# For every pet that the application is for, I see a button to reject the application for that specific pet
# When I click that button
# Then I'm taken back to the admin application show page
# And next to the pet that I rejected, I do not see a button to approve or reject this pet
# And instead I see an indicator next to the pet that they have been rejected
#
# Approved/Rejected Pets on one Application do not affect other Applications
#
# As a visitor
# When there are two applications in the system for the same pet
# When I visit the admin application show page for one of the applications
# And I approve or reject the pet for that application
# When I visit the other application's admin show page
# Then I do not see that the pet has been accepted or rejected for that application
# And instead I see buttons to approve or reject the pet for this specific application
