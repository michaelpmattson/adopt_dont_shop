require 'rails_helper'

RSpec.describe ApplicationPet, type: :model do
  describe 'relationships' do
    it { should belong_to :application }
    it { should belong_to :pet }
  end

  before(:each) do
    @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter.id)
    @pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter.id)

    @app_1 = Application.create!(name: "Cindy Lou Who", address: "123 Some Street", city: "Chicago", state: "IL", zip: "12345", description: "I'm a who for crying out loud.")

    @app_pet_1 = ApplicationPet.create!(pet: @pet_1, application: @app_1)
    @app_pet_2 = ApplicationPet.create!(pet: @pet_2, application: @app_1)
  end

  describe '.instance_methods' do
    describe '.update_status!' do
      it 'changes to Accepted or Rejected' do
        approved = "true"
        @app_pet_1.update_status!(approved)

        expect(@app_pet_1.status).to eq("Accepted")

        approved = "false"
        @app_pet_1.update_status!(approved)

        expect(@app_pet_1.status).to eq("Rejected")
      end
    end
  end
end
