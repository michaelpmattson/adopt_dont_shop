class ApplicationPet < ApplicationRecord
  belongs_to :application
  belongs_to :pet

  def update_status!(approved)
    if approved == 'true'
      update(status: "Accepted")
    elsif approved == 'false'
      update(status: "Rejected")
    end
  end
end
