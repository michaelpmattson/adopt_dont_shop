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

  def any_rejected?
    application_pets.reload
    application_pets.any? do |application_pet|
      application_pet.status == "Rejected"
    end
  end

  def update_adoptable_pets!
    if status == "Approved"
      pets.each do |pet|
        pet.update(adoptable: false)
      end
    end
  end

  def update_status!
    if all_accepted?
      update(status: "Approved")
      update_adoptable_pets!
    elsif any_rejected?
      update(status: "Rejected")
    end
  end
end
