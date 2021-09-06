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
    @application_pet_4 = ApplicationPet.create!(pet: @pet_1, application: @app_2)

    @app_1.update(status: "Pending")
    @app_2.update(status: "Pending")
  end

  it 'has buttons to approve each pet on the app' do
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

  it 'has buttons to approve each pet on the app' do
    visit "/admin/applications/#{@app_1.id}"

    within "#pet-#{@pet_1.id}" do
      click_button("Reject")
    end

    expect(current_path).to eq("/admin/applications/#{@app_1.id}")

    within "#pet-#{@pet_1.id}" do
      expect(page).to_not have_button("Reject")
      expect(page).to     have_content("Rejected")
    end

    within "#pet-#{@pet_4.id}" do
      expect(page).to have_button("Reject")
    end
  end

  it 'does not affect other apps if i approve a pet' do
    visit "/admin/applications/#{@app_1.id}"

    within "#pet-#{@pet_1.id}" do
      click_button("Approve")
    end

    visit "/admin/applications/#{@app_2.id}"

    within "#pet-#{@pet_1.id}" do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end
  end

  it 'does not affect other apps if i reject a pet' do
    visit "/admin/applications/#{@app_1.id}"

    within "#pet-#{@pet_1.id}" do
      click_button("Reject")
    end

    visit "/admin/applications/#{@app_2.id}"

    within "#pet-#{@pet_1.id}" do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end
  end

  context 'when all pets are approved on an admin show page' do
    it 'changes the app status to Approved' do
      visit "/admin/applications/#{@app_1.id}"

      within "#pet-#{@pet_1.id}" do
        click_button("Approve")
      end

      expect(page).to have_content("Application Status: Pending")

      within "#pet-#{@pet_4.id}" do
        click_button("Approve")
      end

      expect(page).to have_content("Application Status: Approved")
    end
  end

  context 'when any pets are rejected on an admin show page' do
    it 'changes the app status to Rejected' do
      visit "/admin/applications/#{@app_1.id}"

      within "#pet-#{@pet_1.id}" do
        click_button("Approve")
      end

      expect(page).to have_content("Application Status: Pending")

      within "#pet-#{@pet_4.id}" do
        click_button("Reject")
      end

      expect(page).to have_content("Application Status: Rejected")
    end
  end
end

# [ ] done
#
# Application Approval makes Pets not adoptable
#
# As a visitor
# When I visit an admin application show page
# And I approve all pets on the application
# And when I visit the show pages for those pets
# Then I see that those pets are no longer "adoptable"
