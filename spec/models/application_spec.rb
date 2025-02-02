require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it { should have_many :application_pets }
    it { should have_many(:pets).through(:application_pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_numericality_of(:zip) }
  end

  before(:each) do
    @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter.id)
    @pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter.id)

    @app_1 = Application.create!(name: "Cindy Lou Who", address: "123 Some Street", city: "Chicago", state: "IL", zip: "12345", description: "I'm a who for crying out loud.")

    @app_pet_1 = ApplicationPet.create!(pet: @pet_1, application: @app_1)
    @app_pet_2 = ApplicationPet.create!(pet: @pet_2, application: @app_1)
  end

  describe 'instance methods' do
    describe '.full_address' do
      it 'combines different parts to make a full address' do
        expect(@app_1.full_address).to eq("123 Some Street, Chicago, IL 12345")
      end
    end

    describe '.approve_pet(pet)' do
      it 'updates the pet status to Accepted' do
        expect(@app_1.application_pet_by_pet(@pet_1)).to eq(@app_pet_1)
      end
    end

    describe '.all_accepted?' do
      it 'checks if all pets are accepted' do
        expect(@app_1.all_accepted?).to eq(false)

        @app_pet_1.update(status: "Accepted")

        expect(@app_1.all_accepted?).to eq(false)

        @app_pet_2.update(status: "Accepted")

        expect(@app_1.all_accepted?).to eq(true)
      end
    end

    describe '.any_rejected?' do
      it 'checks if all pets are accepted' do
        expect(@app_1.any_rejected?).to eq(false)

        @app_pet_1.update(status: "Accepted")

        expect(@app_1.any_rejected?).to eq(false)

        @app_pet_2.update(status: "Rejected")

        expect(@app_1.any_rejected?).to eq(true)
      end
    end

    describe '.update_adoptable_pets!' do
      it 'updates adoptable to false if an app is approved' do
        allow(@app_1).to receive(:status).and_return("Approved")

        @app_1.update_adoptable_pets!

        @pet_1.reload
        @pet_2.reload

        expect(@pet_1.adoptable).to eq(false)
        expect(@pet_2.adoptable).to eq(false)
      end
    end

    describe '.instance_methods' do
      describe '.update_status!' do
        it 'changes to Approved or Rejected' do
          allow(@app_1).to receive(:all_accepted?).and_return(true)
          @app_1.update_status!

          expect(@app_1.status).to eq("Approved")

          allow(@app_1).to receive(:all_accepted?).and_return(false)
          allow(@app_1).to receive(:any_rejected?).and_return(true)
          @app_1.update_status!

          expect(@app_1.status).to eq("Rejected")
        end
      end
    end
  end
end
