class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.reverse_alpha_sort
  end
end
