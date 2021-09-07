class Admin::SheltersController < ApplicationController
  def index
    @shelters         = Shelter.reverse_alpha_sort
    @pending_shelters = Shelter.pending_shelters
  end

  def show
    @shelter_info = Shelter.get_info(params[:id])
  end
end
