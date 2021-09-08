class Admin::SheltersController < ApplicationController
  def index
    @shelters         = Shelter.reverse_alpha_sort
    @pending_shelters = Shelter.pending_shelters
  end

  def show
    @shelter = Shelter.find(params[:id])
  end
end
