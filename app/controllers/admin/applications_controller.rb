class Admin::ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])

  end

  def update
    application = Application.find(params[:id])
    pet         = Pet.find(params[:pet_id])
    application_pet = application.application_pet_by_pet(pet)

    application_pet.update_status!(params[:approved])


    if application.all_accepted?
      application.update(status: "Approved")
      application.update_adoptable_pets!
    elsif application.any_rejected?
      application.update(status: "Rejected")
    end

    redirect_to("/admin/applications/#{application.id}")
  end
end
