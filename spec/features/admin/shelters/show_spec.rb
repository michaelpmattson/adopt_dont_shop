require 'rails_helper'

RSpec.describe 'the admin shelters show page' do
  it 'has the shelters name and full address' do
    shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)

    visit "/admin/shelters/#{shelter_1.id}"
    expect(page).to have_content("Name: Aurora shelter")
    expect(page).to have_content("City: Aurora, CO")

    visit "/admin/shelters/#{shelter_2.id}"
    expect(page).to have_content("Name: RGV animal shelter")
    expect(page).to have_content("City: Harlingen, TX")
  end
end
