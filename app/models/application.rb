class Application < ApplicationRecord
  has_many :application_pets, dependent: :destroy
  has_many :pets, through: :application_pets

  validates :name,    presence: true
  validates :address, presence: true
  validates :city,    presence: true
  validates :state,   presence: true
  validates :zip,     presence: true, numericality: true

  def full_address
    "#{address}, #{city}, #{state} #{zip}"
  end

  def application_pet_by_pet(pet)
    ApplicationPet.where(pet_id: pet.id, application_id: id).first
  end

  def all_accepted?
    application_pets.reload
    application_pets.all? do |application_pet|
      application_pet.status == "Accepted"
    end
  end
end
